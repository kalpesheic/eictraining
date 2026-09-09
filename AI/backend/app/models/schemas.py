from pydantic import BaseModel, Field


class HealthResponse(BaseModel):
    status: str
    service: str


class ProblematicPod(BaseModel):
    name: str
    namespace: str
    status: str
    message: str = ""
    all_issues: list[str] = Field(default_factory=list)


class PodInspectionResult(BaseModel):
    healthy: bool
    problematic_pods: list[ProblematicPod] = Field(default_factory=list)
    total_pods: int = 0
    error: str | None = None


class InvestigationPayload(BaseModel):
    pods: dict
    logs: dict
    events: dict
    deployments: dict
    network: dict


class Diagnosis(BaseModel):
    root_cause: str
    explanation: str
    fix: str
    kubectl_command: str
    prevention_recommendation: str = ""
    confidence: int
    confidence_reasoning: str = ""


class InvestigationResponse(BaseModel):
    status: str
    investigation: InvestigationPayload
    diagnosis: Diagnosis


class InvestigateRequest(BaseModel):
    investigation_id: str | None = None
