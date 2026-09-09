import json
import re
import time

import httpx
from loguru import logger

from app.core.config import settings


def parse_llm_json(content: str) -> dict:
    """Extract and parse JSON from an LLM response."""
    text = content.strip()

    code_block_match = re.search(r"```(?:json)?\s*(\{.*?\})\s*```", text, re.DOTALL)
    if code_block_match:
        text = code_block_match.group(1)

    if not text.startswith("{"):
        brace_match = re.search(r"\{.*\}", text, re.DOTALL)
        if brace_match:
            text = brace_match.group(0)

    try:
        parsed = json.loads(text)
    except json.JSONDecodeError as exc:
        raise ValueError(f"LLM response is not valid JSON: {exc}") from exc

    if not isinstance(parsed, dict):
        raise ValueError("LLM response must be a JSON object")

    return parsed


class OpenRouterClient:
    """HTTP client for OpenRouter chat completions."""

    def __init__(self) -> None:
        self.base_url = settings.openrouter_base_url.rstrip("/")
        self.timeout = settings.openrouter_timeout
        self.max_retries = settings.openrouter_max_retries

    def chat_completion(self, messages: list[dict]) -> dict:
        if not settings.openrouter_api_key:
            raise ValueError("OPENROUTER_API_KEY is not configured")
        if not settings.openrouter_model:
            raise ValueError("OPENROUTER_MODEL is not configured")

        headers = {
            "Authorization": f"Bearer {settings.openrouter_api_key}",
            "Content-Type": "application/json",
        }
        payload = {
            "model": settings.openrouter_model,
            "messages": messages,
            "temperature": 0.2,
        }

        last_error: Exception | None = None

        for attempt in range(1, self.max_retries + 1):
            try:
                logger.info(
                    "Calling OpenRouter model {} (attempt {}/{})",
                    settings.openrouter_model,
                    attempt,
                    self.max_retries,
                )
                with httpx.Client(timeout=self.timeout) as client:
                    response = client.post(
                        f"{self.base_url}/chat/completions",
                        headers=headers,
                        json=payload,
                    )
                    response.raise_for_status()
                    data = response.json()

                content = data["choices"][0]["message"]["content"]
                logger.info("OpenRouter response received")
                return parse_llm_json(content)

            except httpx.TimeoutException as exc:
                last_error = exc
                logger.warning(
                    "OpenRouter request timed out on attempt {}/{}",
                    attempt,
                    self.max_retries,
                )
            except httpx.HTTPStatusError as exc:
                last_error = exc
                logger.error(
                    "OpenRouter HTTP error {}: {}",
                    exc.response.status_code,
                    exc.response.text[:500],
                )
                if exc.response.status_code < 500:
                    break
            except (KeyError, IndexError, ValueError) as exc:
                last_error = exc
                logger.error("Failed to parse OpenRouter response: {}", exc)
                break
            except httpx.HTTPError as exc:
                last_error = exc
                logger.error("OpenRouter request failed: {}", exc)

            if attempt < self.max_retries:
                time.sleep(attempt)

        raise RuntimeError(
            f"OpenRouter request failed after {self.max_retries} attempt(s): {last_error}"
        )
