from collections.abc import Callable

from loguru import logger

from app.kubernetes.deployment_inspector import inspect_deployments
from app.kubernetes.events_analyzer import analyze_events
from app.kubernetes.logs_collector import collect_logs
from app.kubernetes.network_inspector import inspect_network
from app.kubernetes.pod_inspector import inspect_pods


class InvestigationService:
    """Orchestrates Kubernetes evidence collection like a junior DevOps engineer."""

    def run(self, on_progress: Callable[[str], None] | None = None) -> dict:
        logger.info("Starting Kubernetes investigation")

        def progress(step: str) -> None:
            if on_progress:
                on_progress(step)

        progress("Checking Pods")
        pods = inspect_pods()
        logger.info(
            "Pod inspection complete: {} problematic pod(s) found",
            len(pods.get("problematic_pods", [])),
        )

        progress("Reading Logs")
        logs = collect_logs(pods.get("problematic_pods", []))
        logger.info("Log collection complete: {} entr(y/ies)", logs.get("collected", 0))

        progress("Analyzing Events")
        events = analyze_events()
        logger.info(
            "Event analysis complete: {} relevant event(s)",
            events.get("total_relevant_events", len(events.get("findings", []))),
        )

        progress("Inspecting Deployments")
        deployments = inspect_deployments()
        logger.info(
            "Deployment inspection complete: {} unhealthy deployment(s)",
            len(deployments.get("unhealthy_deployments", [])),
        )

        progress("Checking Networking")
        network = inspect_network()
        logger.info(
            "Network inspection complete: {} issue(s)",
            len(network.get("issues", [])),
        )

        investigation = {
            "pods": pods,
            "logs": logs,
            "events": events,
            "deployments": deployments,
            "network": network,
        }

        logger.info("Kubernetes investigation finished")
        return investigation


def run_investigation(on_progress: Callable[[str], None] | None = None) -> dict:
    return InvestigationService().run(on_progress=on_progress)
