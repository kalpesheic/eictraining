"use client";

import { INVESTIGATION_STEPS } from "@/types";

interface InvestigationProgressProps {
  completedSteps: string[];
  currentStep: string | null;
  isInvestigating: boolean;
}

export function InvestigationProgress({
  completedSteps,
  currentStep,
  isInvestigating,
}: InvestigationProgressProps) {
  if (!isInvestigating && completedSteps.length === 0) {
    return null;
  }

  return (
    <section className="rounded-xl border border-slate-800 bg-slate-900/50 p-6">
      <h2 className="text-sm font-semibold uppercase tracking-wide text-slate-400">
        Investigation Status
      </h2>
      <ul className="mt-4 space-y-2">
        {INVESTIGATION_STEPS.map((step) => {
          const isComplete = completedSteps.includes(step);
          const isActive = currentStep === step && !isComplete;

          return (
            <li
              key={step}
              className={`flex items-center gap-3 text-sm ${
                isComplete
                  ? "text-emerald-400"
                  : isActive
                    ? "text-blue-400"
                    : "text-slate-600"
              }`}
            >
              <span className="w-5 text-center font-mono">
                {isComplete ? "✓" : isActive ? "…" : "○"}
              </span>
              <span>{step}</span>
            </li>
          );
        })}
      </ul>
    </section>
  );
}
