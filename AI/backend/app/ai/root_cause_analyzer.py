def _summarize_evidence(investigation: dict) -> list[str]:
    signals: list[str] = []

    pods = investigation.get("pods", {})
    for pod in pods.get("problematic_pods", []):
        signals.append(
            f"Pod {pod.get('namespace')}/{pod.get('name')} is {pod.get('status')}"
        )

    logs = investigation.get("logs", {}).get("entries", {})
    for entry in logs.values():
        for highlight in entry.get("highlights", [])[:2]:
            signals.append(f"Log signal: {highlight[:200]}")

    events = investigation.get("events", {}).get("findings", [])
    for event in events[-3:]:
        signals.append(
            f"Event {event.get('reason')} on {event.get('object_name')}: "
            f"{event.get('message', '')[:200]}"
        )

    deployments = investigation.get("deployments", {}).get("unhealthy_deployments", [])
    for deployment in deployments[:3]:
        signals.append(
            f"Deployment {deployment.get('namespace')}/{deployment.get('name')} "
            f"has {deployment.get('unavailable_replicas', 0)} unavailable replica(s)"
        )

    network = investigation.get("network", {}).get("issues", [])
    for issue in network[:3]:
        signals.append(
            f"Network issue on {issue.get('namespace')}/{issue.get('service')}: "
            f"{issue.get('message', '')[:200]}"
        )

    return signals


def analyze_root_cause(investigation: dict, llm_response: dict) -> dict:
    """Correlate investigation evidence with LLM reasoning to produce root cause."""
    root_cause = str(llm_response.get("root_cause", "")).strip()
    explanation = str(llm_response.get("explanation", "")).strip()

    if not root_cause:
        signals = _summarize_evidence(investigation)
        if signals:
            root_cause = signals[0]
            explanation = (
                "Unable to extract a definitive root cause from the LLM response. "
                "Primary evidence signals: " + "; ".join(signals[:5])
            )
        else:
            root_cause = "No clear Kubernetes failure detected"
            explanation = (
                "The investigation did not find problematic pods, deployments, "
                "network issues, or relevant error events."
            )

    evidence_signals = _summarize_evidence(investigation)
    if evidence_signals and explanation:
        explanation = (
            f"{explanation}\n\nEvidence considered:\n- "
            + "\n- ".join(evidence_signals[:8])
        )

    return {
        "root_cause": root_cause,
        "explanation": explanation,
    }
