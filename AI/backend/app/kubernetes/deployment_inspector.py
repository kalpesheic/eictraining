from app.kubernetes.kubectl import run_kubectl


def _extract_condition_issues(conditions: list[dict]) -> list[dict]:
    issues: list[dict] = []

    for condition in conditions:
        condition_type = condition.get("type", "Unknown")
        status = condition.get("status", "Unknown")
        reason = condition.get("reason", "")
        message = condition.get("message", "")

        if status == "False" and condition_type in {"Available", "Progressing"}:
            issues.append({
                "type": condition_type,
                "reason": reason,
                "message": message,
            })

        if reason in {"ProgressDeadlineExceeded", "ReplicaSetCreateError"}:
            issues.append({
                "type": condition_type,
                "reason": reason,
                "message": message,
            })

    return issues


def inspect_deployments() -> dict:
    """Inspect deployments for replica and rollout issues."""
    result = run_kubectl(["get", "deployments", "-A", "-o", "json"])

    if not result.success:
        return {
            "healthy": True,
            "unhealthy_deployments": [],
            "total_deployments": 0,
            "error": result.stderr.strip(),
        }

    data = result.parse_json()
    items = data.get("items", []) if isinstance(data, dict) else []

    unhealthy_deployments: list[dict] = []

    for deployment in items:
        metadata = deployment.get("metadata", {})
        spec = deployment.get("spec", {})
        status = deployment.get("status", {})

        name = metadata.get("name", "unknown")
        namespace = metadata.get("namespace", "default")
        desired_replicas = spec.get("replicas", 0) or 0
        available_replicas = status.get("availableReplicas", 0) or 0
        ready_replicas = status.get("readyReplicas", 0) or 0
        unavailable_replicas = status.get("unavailableReplicas", 0) or 0
        updated_replicas = status.get("updatedReplicas", 0) or 0

        conditions = status.get("conditions", [])
        condition_issues = _extract_condition_issues(conditions)

        rollout_failed = any(
            issue.get("reason") == "ProgressDeadlineExceeded"
            for issue in condition_issues
        )

        is_unhealthy = (
            unavailable_replicas > 0
            or available_replicas < desired_replicas
            or ready_replicas < desired_replicas
            or rollout_failed
            or bool(condition_issues)
        )

        if not is_unhealthy:
            continue

        unhealthy_deployments.append({
            "name": name,
            "namespace": namespace,
            "desired_replicas": desired_replicas,
            "available_replicas": available_replicas,
            "ready_replicas": ready_replicas,
            "unavailable_replicas": unavailable_replicas,
            "updated_replicas": updated_replicas,
            "rollout_failed": rollout_failed,
            "conditions": condition_issues,
        })

    return {
        "healthy": len(unhealthy_deployments) == 0,
        "unhealthy_deployments": unhealthy_deployments,
        "total_deployments": len(items),
    }
