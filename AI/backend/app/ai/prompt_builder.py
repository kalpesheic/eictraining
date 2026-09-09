import json
import re

SYSTEM_PROMPT = """You are a Senior Kubernetes SRE responsible for incident troubleshooting.

Your job is to analyze collected Kubernetes evidence and produce a precise, actionable diagnosis.

Rules:
- Correlate pod status, logs, events, deployment health, and networking findings together.
- Identify the most likely root cause, not just the first error you see.
- Be specific to Kubernetes and the evidence provided.
- Avoid vague advice like "check the logs" or "restart the pod" unless justified.
- Prefer concrete kubectl commands that a beginner can run.
- Return ONLY valid JSON matching the requested schema. No markdown, no prose outside JSON.
"""


def _format_section(title: str, data: dict) -> str:
    return f"## {title}\n{json.dumps(data, indent=2)}"


def build_messages(investigation: dict) -> list[dict]:
    """Build structured prompts for LLM reasoning from investigation evidence."""
    user_prompt = f"""Analyze the Kubernetes investigation evidence below and determine the root cause.

Required JSON response schema:
{{
  "root_cause": "One concise sentence describing the primary root cause",
  "explanation": "Detailed explanation correlating pods, logs, events, deployments, and network evidence",
  "fix": "Practical step-by-step fix a beginner can apply",
  "kubectl_command": "Primary kubectl command to apply or inspect the fix",
  "prevention_recommendation": "How to prevent this issue in the future",
  "confidence": 0,
  "confidence_reasoning": "Why this confidence score is appropriate based on the evidence"
}}

Confidence must be an integer from 0 to 100.

{_format_section("Pod Status", investigation.get("pods", {}))}

{_format_section("Logs", investigation.get("logs", {}))}

{_format_section("Events", investigation.get("events", {}))}

{_format_section("Deployment Health", investigation.get("deployments", {}))}

{_format_section("Networking Findings", investigation.get("network", {}))}
"""

    return [
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": user_prompt},
    ]
