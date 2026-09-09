from loguru import logger

from app.ai.confidence_engine import compute_confidence
from app.ai.fix_recommendation import build_fix_recommendation
from app.ai.llm_client import OpenRouterClient
from app.ai.prompt_builder import build_messages
from app.ai.root_cause_analyzer import analyze_root_cause


def _fallback_diagnosis(investigation: dict, error_message: str) -> dict:
    root = analyze_root_cause(investigation, {})
    fix = build_fix_recommendation(investigation, {})
    confidence = compute_confidence(investigation, {"confidence": 0})

    return {
        **root,
        **fix,
        **confidence,
        "explanation": (
            f"{root['explanation']}\n\nAI reasoning unavailable: {error_message}"
        ),
    }


def analyze_investigation(investigation: dict) -> dict:
    """Run the AI Kubernetes agent on collected investigation evidence."""
    logger.info("Starting AI reasoning on investigation evidence")

    try:
        messages = build_messages(investigation)
        llm_response = OpenRouterClient().chat_completion(messages)

        root = analyze_root_cause(investigation, llm_response)
        fix = build_fix_recommendation(investigation, llm_response)
        confidence = compute_confidence(investigation, llm_response)

        diagnosis = {
            **root,
            **fix,
            **confidence,
        }

        logger.info(
            "AI diagnosis complete with {}% confidence",
            diagnosis.get("confidence", 0),
        )
        return diagnosis

    except Exception as exc:
        logger.error("AI reasoning failed: {}", exc)
        return _fallback_diagnosis(investigation, str(exc))


def analyze_cluster_state(investigation: dict) -> dict:
    return analyze_investigation(investigation)


def generate_diagnosis(investigation: dict) -> dict:
    return analyze_investigation(investigation)
