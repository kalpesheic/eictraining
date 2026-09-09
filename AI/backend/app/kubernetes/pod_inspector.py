from datetime import datetime, timezone

from app.kubernetes.kubectl import run_kubectl

PROBLEMATIC_STATUSES = {
    "CrashLoopBackOff",
    "ImagePullBackOff",
    "ErrImagePull",
    "Pending",
    "Error",
    "OOMKilled",
    "ContainerCreating",
    "CreateContainerConfigError",
    "InvalidImageName",
}

STUCK_CONTAINER_CREATING_MINUTES = 5


def _parse_timestamp(value: str | None) -> datetime | None:
    if not value:
        return None
    try:
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        return None


def _is_stuck_container_creating(started_at: str | None) -> bool:
    started = _parse_timestamp(started_at)
    if not started:
        return False
    age_minutes = (datetime.now(timezone.utc) - started).total_seconds() / 60
    return age_minutes >= STUCK_CONTAINER_CREATING_MINUTES


def _collect_container_issues(
    container_statuses: list[dict],
    pod_created_at: str | None,
) -> list[dict]:
    issues: list[dict] = []

    for container in container_statuses:
        state = container.get("state", {})
        waiting = state.get("waiting", {})
        terminated = state.get("terminated", {})

        if waiting:
            reason = waiting.get("reason", "Unknown")
            message = waiting.get("message", "")

            if reason == "ContainerCreating":
                if _is_stuck_container_creating(pod_created_at):
                    issues.append({
                        "status": "ContainerCreating",
                        "message": message or "Stuck in ContainerCreating",
                    })
            elif reason in PROBLEMATIC_STATUSES:
                issues.append({"status": reason, "message": message})

        if terminated:
            reason = terminated.get("reason", "")
            if reason in PROBLEMATIC_STATUSES:
                issues.append({
                    "status": reason,
                    "message": terminated.get("message", ""),
                })

    return issues


def inspect_pods() -> dict:
    """Get pod status and detect unhealthy pods across all namespaces."""
    result = run_kubectl(["get", "pods", "-A", "-o", "json"])
    if not result.success:
        return {
            "healthy": True,
            "problematic_pods": [],
            "total_pods": 0,
            "error": result.stderr.strip(),
        }

    data = result.parse_json()
    items = data.get("items", []) if isinstance(data, dict) else []

    problematic_pods: list[dict] = []

    for pod in items:
        metadata = pod.get("metadata", {})
        status = pod.get("status", {})
        name = metadata.get("name", "unknown")
        namespace = metadata.get("namespace", "default")
        phase = status.get("phase", "Unknown")

        issues: list[dict] = []

        if phase == "Pending":
            issues.append({"status": "Pending", "message": status.get("message", "")})

        if phase == "Failed":
            issues.append({"status": "Error", "message": status.get("message", "") or "Pod is in Failed phase"})

        container_statuses = (
            status.get("containerStatuses", [])
            + status.get("initContainerStatuses", [])
        )
        pod_created_at = metadata.get("creationTimestamp")
        issues.extend(_collect_container_issues(container_statuses, pod_created_at))

        if not issues:
            continue

        primary = issues[0]
        problematic_pods.append({
            "name": name,
            "namespace": namespace,
            "status": primary["status"],
            "message": primary.get("message", ""),
            "all_issues": [issue["status"] for issue in issues],
        })

    return {
        "healthy": len(problematic_pods) == 0,
        "problematic_pods": problematic_pods,
        "total_pods": len(items),
    }
