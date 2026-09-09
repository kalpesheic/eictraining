import axios from "axios";

import type { InvestigationResponse } from "@/types";

const apiBaseUrl =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:8000";

export const apiClient = axios.create({
  baseURL: apiBaseUrl,
  headers: {
    "Content-Type": "application/json",
  },
  timeout: 120_000,
});

export async function checkHealth(): Promise<{ status: string; service: string }> {
  const response = await apiClient.get("/health");
  return response.data;
}

export async function investigateCluster(
  investigationId?: string,
): Promise<InvestigationResponse> {
  const response = await apiClient.post<InvestigationResponse>("/investigate", {
    investigation_id: investigationId ?? null,
  });
  return response.data;
}

export function getApiErrorMessage(error: unknown): string {
  if (axios.isAxiosError(error)) {
    if (error.code === "ECONNABORTED") {
      return "Investigation timed out. The cluster may be large — try again.";
    }
    const detail = error.response?.data?.detail;
    if (typeof detail === "string") {
      return detail;
    }
    if (error.response?.status === 500) {
      return "Investigation failed on the server.";
    }
    if (!error.response) {
      return "Cannot reach the backend. Is it running?";
    }
    return error.message;
  }
  if (error instanceof Error) {
    return error.message;
  }
  return "An unexpected error occurred.";
}
