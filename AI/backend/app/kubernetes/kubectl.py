import json
import subprocess
from dataclasses import dataclass, field

from loguru import logger

from app.core.config import settings


@dataclass
class KubectlResult:
    success: bool
    stdout: str
    stderr: str
    return_code: int
    command: list[str] = field(default_factory=list)

    def parse_json(self) -> dict | list | None:
        if not self.success or not self.stdout.strip():
            return None
        try:
            return json.loads(self.stdout)
        except json.JSONDecodeError:
            logger.warning("Failed to parse kubectl JSON output")
            return None


def run_kubectl(args: list[str], timeout: int = 60) -> KubectlResult:
    """Execute a kubectl command and return structured output."""
    command = ["kubectl"]
    if settings.kubeconfig_path:
        command.extend(["--kubeconfig", settings.kubeconfig_path])
    command.extend(args)

    logger.info("Executing: {}", " ".join(command))

    try:
        completed = subprocess.run(
            command,
            capture_output=True,
            text=True,
            timeout=timeout,
            check=False,
        )
        result = KubectlResult(
            success=completed.returncode == 0,
            stdout=completed.stdout,
            stderr=completed.stderr,
            return_code=completed.returncode,
            command=command,
        )
        if not result.success:
            logger.warning(
                "kubectl failed (exit {}): {}",
                completed.returncode,
                (completed.stderr or completed.stdout).strip(),
            )
        return result
    except subprocess.TimeoutExpired:
        logger.error("kubectl command timed out after {}s", timeout)
        return KubectlResult(
            success=False,
            stdout="",
            stderr=f"Command timed out after {timeout} seconds",
            return_code=-1,
            command=command,
        )
    except FileNotFoundError:
        logger.error("kubectl binary not found in PATH")
        return KubectlResult(
            success=False,
            stdout="",
            stderr="kubectl not found. Ensure kubectl is installed and in PATH.",
            return_code=-1,
            command=command,
        )
