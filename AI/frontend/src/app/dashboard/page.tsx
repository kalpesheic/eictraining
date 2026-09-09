"use client";

import { useCallback, useEffect, useState } from "react";
import { useRouter } from "next/navigation";

import { signOut } from "@/app/actions/auth";
import {
  DiagnosisCard,
  InvestigationHistory,
  InvestigationProgress,
} from "@/components";
import { useInvestigation } from "@/hooks/useInvestigation";
import { getInsforgeBrowserClient } from "@/lib/insforge";
import type { InvestigationRecord } from "@/types";

export default function DashboardPage() {
  const router = useRouter();
  const [userId, setUserId] = useState<string | undefined>();
  const [history, setHistory] = useState<InvestigationRecord[]>([]);
  const [historyLoading, setHistoryLoading] = useState(true);

  const loadHistory = useCallback(async () => {
    const insforge = getInsforgeBrowserClient();
    const { data, error } = await insforge.database
      .from("investigations")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(10);

    if (!error && data) {
      setHistory(data as InvestigationRecord[]);
    }
    setHistoryLoading(false);
  }, []);

  useEffect(() => {
    async function init() {
      const insforge = getInsforgeBrowserClient();
      const { data } = await insforge.auth.getCurrentUser();

      if (!data?.user?.id) {
        router.replace("/login");
        return;
      }

      setUserId(data.user.id);
      await loadHistory();
    }

    void init();
  }, [router, loadHistory]);

  const {
    completedSteps,
    currentStep,
    diagnosis,
    error,
    isInvestigating,
    startInvestigation,
  } = useInvestigation(userId, loadHistory);

  async function handleSignOut() {
    await signOut();
    router.replace("/login");
    router.refresh();
  }

  return (
    <main className="min-h-screen px-4 py-10">
      <div className="mx-auto max-w-3xl space-y-8">
        <header className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold tracking-tight text-white">
              AI Kubernetes Agent
            </h1>
            <p className="mt-1 text-sm text-slate-400">
              Troubleshoot Kubernetes with AI
            </p>
          </div>
          <button
            type="button"
            onClick={handleSignOut}
            className="rounded-lg border border-slate-700 px-3 py-1.5 text-sm text-slate-400 transition hover:border-slate-500 hover:text-white"
          >
            Sign Out
          </button>
        </header>

        <button
          type="button"
          onClick={() => void startInvestigation()}
          disabled={isInvestigating || !userId}
          className="w-full rounded-lg bg-blue-600 px-6 py-3 text-sm font-semibold text-white transition hover:bg-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2 focus:ring-offset-slate-950 disabled:cursor-not-allowed disabled:opacity-60"
        >
          {isInvestigating ? "Investigating…" : "Investigate Cluster"}
        </button>

        {error && (
          <div className="rounded-xl border border-red-900/50 bg-red-950/30 px-4 py-3 text-sm text-red-400">
            {error}
          </div>
        )}

        <InvestigationProgress
          completedSteps={completedSteps}
          currentStep={currentStep}
          isInvestigating={isInvestigating}
        />

        <DiagnosisCard diagnosis={diagnosis} />

        <InvestigationHistory records={history} isLoading={historyLoading} />
      </div>
    </main>
  );
}
