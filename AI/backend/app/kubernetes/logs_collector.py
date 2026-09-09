import re

from app.kubernetes.kubectl import run_kubectl

MAX_LOG_LINES = 80
MAX_PODS_TO_COLLECT = 10
MAX_LOG_CHARS = 4000

HIGHLIGHT_PATTERNS = [
    re.compile(r"(?i)exception"),
    re.compile(r"(?i)error"),
    re.compile(r"(?i)failed"),
    re.compile(r"(?i)connection refused"),
    re.compile(r"(?i)connection reset"),
    re.compile(r"(?i)no such file"),
    re.compile(r"(?i)env.*not (set|found)"),
    re.compile(r"(?i)image.*pull"),
    re.compile(r"(?i)crash"),
    re.compile(r"(?i)fatal"),
    re.compile(r"(?i)panic"),
    re.compile(r"(?i)startup"),
]


def _extract_highlights(log_text: str, limit: int = 15) -> list[str]:
    highlights: list[str] = []
    seen: set[str] = set()

    for line in log_text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if any(pattern.search(stripped) for pattern in HIGHLIGHT_PATTERNS):
            if stripped not in seen:
                seen.add(stripped)
                highlights.append(stripped[:300])
        if len(highlights) >= limit:
            break

    return highlights


def collect_logs(problematic_pods: list[dict]) -> dict:
    """Fetch concise logs for failed or unhealthy pods."""
    if not problematic_pods:
        return {
            "collected": 0,
            "entries": {},
            "summary": "No problematic pods found; log collection skipped.",
        }

    entries: dict[str, dict] = {}

    for pod in problematic_pods[:MAX_PODS_TO_COLLECT]:
        name = pod["name"]
        namespace = pod["namespace"]
        key = f"{namespace}/{name}"

        result = run_kubectl([
            "logs",
            name,
            "-n",
            namespace,
            "--tail",
            str(MAX_LOG_LINES),
            "--all-containers=true",
        ])

        if not result.success:
            previous_result = run_kubectl([
                "logs",
                name,
                "-n",
                namespace,
                "--tail",
                str(MAX_LOG_LINES),
                "--all-containers=true",
                "--previous",
            ])
            result = previous_result if previous_result.success else result

        if result.success:
            log_text = result.stdout.strip()[-MAX_LOG_CHARS:]
            entries[key] = {
                "pod": name,
                "namespace": namespace,
                "status": pod.get("status", "Unknown"),
                "logs": log_text,
                "highlights": _extract_highlights(log_text),
            }
        else:
            entries[key] = {
                "pod": name,
                "namespace": namespace,
                "status": pod.get("status", "Unknown"),
                "logs": "",
                "error": result.stderr.strip(),
                "highlights": [],
            }

    return {
        "collected": len(entries),
        "entries": entries,
        "summary": f"Collected logs for {len(entries)} pod(s).",
    }
