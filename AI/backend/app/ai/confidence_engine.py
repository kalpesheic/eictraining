def _count_evidence_signals(investigation: dict) -> int:
    pods = len(investigation.get("pods", {}).get("problematic_pods", []))
    logs = len(investigation.get("logs", {}).get("entries", {}))
    events = len(investigation.get("events", {}).get("findings", []))
    deployments = len(
        investigation.get("deployments", {}).get("unhealthy_deployments", [])
    )
    network = len(investigation.get("network", {}).get("issues", []))
    return pods + logs + events + deployments + network


def compute_confidence(investigation: dict, llm_response: dict) -> dict:
    """Normalize and explain the confidence score for the diagnosis."""
    raw_confidence = llm_response.get("confidence", 0)
    confidence_reasoning = str(
        llm_response.get("confidence_reasoning", "")
    ).strip()

    try:
        confidence = int(raw_confidence)
    except (TypeError, ValueError):
        confidence = 0

    confidence = max(0, min(100, confidence))

    evidence_count = _count_evidence_signals(investigation)
    if evidence_count == 0 and confidence > 40:
        confidence = min(confidence, 40)
        confidence_reasoning = (
            (confidence_reasoning + " ").strip()
            + "Confidence reduced because minimal failure evidence was collected."
        ).strip()
    elif evidence_count >= 3 and confidence < 50:
        confidence = min(confidence + 10, 100)
        if not confidence_reasoning:
            confidence_reasoning = (
                "Confidence increased because multiple independent evidence sources "
                "support the diagnosis."
            )

    if not confidence_reasoning:
        if confidence >= 80:
            confidence_reasoning = (
                "High confidence because multiple evidence sources align on the same failure."
            )
        elif confidence >= 50:
            confidence_reasoning = (
                "Moderate confidence because evidence suggests a likely cause but "
                "may need verification."
            )
        else:
            confidence_reasoning = (
                "Low confidence because evidence is limited or ambiguous."
            )

    return {
        "confidence": confidence,
        "confidence_reasoning": confidence_reasoning,
    }
