"use client";

import { useCallback, useEffect, useRef, useState } from "react";

import { getInsforgeBrowserClient, investigationChannel } from "@/lib/insforge";
import { getApiErrorMessage, investigateCluster } from "@/services/api";
import {
  INVESTIGATION_STEPS,
  type Diagnosis,
  type InvestigationRecord,
  type InvestigationResponse,
  type ProgressEvent,
} from "@/types";

function extractNamespace(investigation: InvestigationResponse["investigation"]): string {
  const pods = investigation.pods as {
    problematic_pods?: Array<{ namespace?: string }>;
  };
  return pods.problematic_pods?.[0]?.namespace ?? "default";
}

interface UseInvestigationResult {
  completedSteps: string[];
  currentStep: string | null;
  diagnosis: Diagnosis | null;
  error: string | null;
  isInvestigating: boolean;
  startInvestigation: () => Promise<void>;
  reset: () => void;
}

export function useInvestigation(
  userId: string | undefined,
  onHistoryUpdate: () => void,
): UseInvestigationResult {
  const [completedSteps, setCompletedSteps] = useState<string[]>([]);
  const [currentStep, setCurrentStep] = useState<string | null>(null);
  const [diagnosis, setDiagnosis] = useState<Diagnosis | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isInvestigating, setIsInvestigating] = useState(false);
  const activeChannelRef = useRef<string | null>(null);

  const reset = useCallback(() => {
    setCompletedSteps([]);
    setCurrentStep(null);
    setDiagnosis(null);
    setError(null);
  }, []);

  const handleProgress = useCallback((event: ProgressEvent) => {
    setCompletedSteps((prev) => {
      if (prev.includes(event.step)) {
        return prev;
      }
      return [...prev, event.step];
    });
    setCurrentStep(event.step);
  }, []);

  useEffect(() => {
    return () => {
      const insforge = getInsforgeBrowserClient();
      if (activeChannelRef.current) {
        insforge.realtime.unsubscribe(activeChannelRef.current);
      }
      insforge.realtime.disconnect();
    };
  }, []);

  const startInvestigation = useCallback(async () => {
    if (!userId || isInvestigating) {
      return;
    }

    reset();
    setIsInvestigating(true);
    setError(null);

    const insforge = getInsforgeBrowserClient();
    let investigationId: string | null = null;

    try {
      const { data: record, error: insertError } = await insforge.database
        .from("investigations")
        .insert({
          user_id: userId,
          status: "in_progress",
        })
        .select()
        .single();

      if (insertError || !record) {
        throw new Error(insertError?.message ?? "Failed to create investigation record.");
      }

      investigationId = (record as InvestigationRecord).id;
      const channel = investigationChannel(investigationId);
      activeChannelRef.current = channel;

      await insforge.realtime.connect();
      const subscription = await insforge.realtime.subscribe(channel);

      if (!subscription.ok) {
        throw new Error(
          subscription.error?.message ?? "Failed to subscribe to progress updates.",
        );
      }

      insforge.realtime.on("progress", (message) => {
        handleProgress(message as ProgressEvent);
      });

      const response = await investigateCluster(investigationId);

      setDiagnosis(response.diagnosis);

      const namespace = extractNamespace(response.investigation);
      await insforge.database
        .from("investigations")
        .update({
          status: "completed",
          root_cause: response.diagnosis.root_cause,
          namespace,
          confidence: response.diagnosis.confidence,
          explanation: response.diagnosis.explanation,
          suggested_fix: response.diagnosis.fix,
          kubectl_command: response.diagnosis.kubectl_command,
        })
        .eq("id", investigationId);

      setCompletedSteps([...INVESTIGATION_STEPS]);
      setCurrentStep(null);
      onHistoryUpdate();
    } catch (err) {
      setError(getApiErrorMessage(err));

      if (investigationId) {
        await insforge.database
          .from("investigations")
          .update({ status: "failed" })
          .eq("id", investigationId);
        onHistoryUpdate();
      }
    } finally {
      if (activeChannelRef.current) {
        insforge.realtime.off("progress");
        insforge.realtime.unsubscribe(activeChannelRef.current);
        activeChannelRef.current = null;
      }
      setIsInvestigating(false);
    }
  }, [userId, isInvestigating, reset, handleProgress, onHistoryUpdate]);

  return {
    completedSteps,
    currentStep,
    diagnosis,
    error,
    isInvestigating,
    startInvestigation,
    reset,
  };
}
