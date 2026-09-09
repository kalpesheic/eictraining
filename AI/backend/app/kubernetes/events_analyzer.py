from app.kubernetes.kubectl import run_kubectl

INTERESTING_EVENT_REASONS = {
    "FailedScheduling",
    "BackOff",
    "FailedMount",
    "FailedPull",
    "ErrImagePull",
    "Unhealthy",
    "FailedCreate",
    "FailedKillPod",
    "NetworkNotReady",
}


def _is_interesting_event(reason: str) -> bool:
    if reason in INTERESTING_EVENT_REASONS:
        return True
    return any(keyword in reason for keyword in INTERESTING_EVENT_REASONS)


def analyze_events() -> dict:
    """Read cluster events and summarize troubleshooting-relevant findings."""
    result = run_kubectl([
        "get",
        "events",
        "-A",
        "--sort-by=.lastTimestamp",
        "-o",
        "json",
    ])

    if not result.success:
        return {
            "summary": "Failed to read Kubernetes events.",
            "findings": [],
            "error": result.stderr.strip(),
        }

    data = result.parse_json()
    items = data.get("items", []) if isinstance(data, dict) else []

    findings: list[dict] = []

    for event in items:
        reason = event.get("reason", "")
        if not _is_interesting_event(reason):
            continue

        involved = event.get("involvedObject", {})
        findings.append({
            "namespace": event.get("metadata", {}).get("namespace", "default"),
            "object_kind": involved.get("kind", "Unknown"),
            "object_name": involved.get("name", "unknown"),
            "reason": reason,
            "message": event.get("message", ""),
            "type": event.get("type", "Unknown"),
            "count": event.get("count", 1),
        })

    recent_findings = findings[-50:]

    return {
        "summary": f"Found {len(findings)} relevant event(s).",
        "findings": recent_findings,
        "total_relevant_events": len(findings),
    }
