export const INVESTIGATION_STEPS = [
  "Checking Pods",
  "Reading Logs",
  "Analyzing Events",
  "Inspecting Deployments",
  "Checking Networking",
  "AI Reasoning",
  "Root Cause Found",
] as const;

export type InvestigationStep = (typeof INVESTIGATION_STEPS)[number];

export interface HealthResponse {
  status: string;
  service: string;
}

export interface Diagnosis {
  root_cause: string;
  explanation: string;
  fix: string;
  kubectl_command: string;
  prevention_recommendation?: string;
  confidence: number;
  confidence_reasoning?: string;
}

export interface InvestigationPayload {
  pods: Record<string, unknown>;
  logs: Record<string, unknown>;
  events: Record<string, unknown>;
  deployments: Record<string, unknown>;
  network: Record<string, unknown>;
}

export interface InvestigationResponse {
  status: string;
  investigation: InvestigationPayload;
  diagnosis: Diagnosis;
}

export interface InvestigationRecord {
  id: string;
  user_id: string;
  timestamp: string;
  root_cause: string | null;
  namespace: string | null;
  confidence: number | null;
  status: string;
  explanation: string | null;
  suggested_fix: string | null;
  kubectl_command: string | null;
  created_at: string;
}

export interface ProgressEvent {
  step: string;
  status: string;
}
