from app.kubernetes.kubectl import run_kubectl


def _pod_matches_selector(labels: dict, selector: dict) -> bool:
    return all(labels.get(key) == value for key, value in selector.items())


def inspect_network() -> dict:
    """Inspect services and networking for common misconfiguration issues."""
    svc_result = run_kubectl(["get", "svc", "-A", "-o", "json"])
    ep_result = run_kubectl(["get", "endpoints", "-A", "-o", "json"])
    pod_result = run_kubectl(["get", "pods", "-A", "-o", "json"])

    if not svc_result.success:
        return {
            "healthy": True,
            "issues": [],
            "summary": "Failed to inspect services.",
            "error": svc_result.stderr.strip(),
        }

    services_data = svc_result.parse_json()
    endpoints_data = ep_result.parse_json() if ep_result.success else {"items": []}
    pods_data = pod_result.parse_json() if pod_result.success else {"items": []}

    services = services_data.get("items", []) if isinstance(services_data, dict) else []
    endpoints = endpoints_data.get("items", []) if isinstance(endpoints_data, dict) else []
    pods = pods_data.get("items", []) if isinstance(pods_data, dict) else []

    endpoint_map: dict[tuple[str, str], dict] = {}
    for endpoint in endpoints:
        metadata = endpoint.get("metadata", {})
        key = (metadata.get("namespace", "default"), metadata.get("name", ""))
        endpoint_map[key] = endpoint

    pods_by_namespace: dict[str, list[dict]] = {}
    for pod in pods:
        namespace = pod.get("metadata", {}).get("namespace", "default")
        pods_by_namespace.setdefault(namespace, []).append(pod)

    issues: list[dict] = []

    for service in services:
        metadata = service.get("metadata", {})
        spec = service.get("spec", {})
        name = metadata.get("name", "unknown")
        namespace = metadata.get("namespace", "default")
        service_type = spec.get("type", "ClusterIP")
        selector = spec.get("selector") or {}
        cluster_ip = spec.get("clusterIP", "")

        if cluster_ip == "None":
            continue

        if service_type == "ExternalName":
            external_name = spec.get("externalName", "")
            if not external_name:
                issues.append({
                    "type": "dns_configuration",
                    "service": name,
                    "namespace": namespace,
                    "message": "ExternalName service is missing externalName target.",
                })
            continue

        if not selector and service_type in {"ClusterIP", "NodePort", "LoadBalancer"}:
            issues.append({
                "type": "missing_selector",
                "service": name,
                "namespace": namespace,
                "message": "Service has no selector defined.",
            })
            continue

        matching_pods = [
            pod
            for pod in pods_by_namespace.get(namespace, [])
            if _pod_matches_selector(
                pod.get("metadata", {}).get("labels", {}),
                selector,
            )
        ]

        if selector and not matching_pods:
            issues.append({
                "type": "selector_mismatch",
                "service": name,
                "namespace": namespace,
                "selector": selector,
                "message": "No pods match the service selector.",
            })

        endpoint = endpoint_map.get((namespace, name))
        if endpoint is None:
            if service_type in {"ClusterIP", "NodePort", "LoadBalancer"}:
                issues.append({
                    "type": "missing_endpoints",
                    "service": name,
                    "namespace": namespace,
                    "message": "No endpoints object found for service.",
                })
            continue

        subsets = endpoint.get("subsets", []) or []
        has_ready_addresses = any(
            subset.get("addresses")
            for subset in subsets
        )

        if not has_ready_addresses:
            issues.append({
                "type": "missing_endpoints",
                "service": name,
                "namespace": namespace,
                "message": "Service has no ready endpoint addresses.",
            })

    return {
        "healthy": len(issues) == 0,
        "issues": issues,
        "total_services": len(services),
        "summary": f"Found {len(issues)} networking issue(s).",
    }
