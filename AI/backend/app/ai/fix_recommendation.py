def build_fix_recommendation(investigation: dict, llm_response: dict) -> dict:
    """Generate actionable Kubernetes fix recommendations."""
    fix = str(llm_response.get("fix", "")).strip()
    kubectl_command = str(llm_response.get("kubectl_command", "")).strip()
    prevention = str(llm_response.get("prevention_recommendation", "")).strip()

    if not fix:
        pods = investigation.get("pods", {}).get("problematic_pods", [])
        if pods:
            pod = pods[0]
            fix = (
                f"Inspect pod {pod.get('namespace')}/{pod.get('name')} and resolve "
                f"its {pod.get('status')} condition."
            )
        else:
            fix = "Review the collected investigation evidence and validate cluster health."

    if not kubectl_command:
        pods = investigation.get("pods", {}).get("problematic_pods", [])
        if pods:
            pod = pods[0]
            kubectl_command = (
                f"kubectl describe pod {pod.get('name')} -n {pod.get('namespace')}"
            )
        else:
            kubectl_command = "kubectl get pods -A"

    if not prevention:
        prevention = (
            "Add readiness/liveness probes, resource limits, and validate "
            "configuration in CI before deployment."
        )

    return {
        "fix": fix,
        "kubectl_command": kubectl_command,
        "prevention_recommendation": prevention,
    }
