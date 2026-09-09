"use client";

import type { Diagnosis } from "@/types";

interface DiagnosisCardProps {
  diagnosis: Diagnosis | null;
}

export function DiagnosisCard({ diagnosis }: DiagnosisCardProps) {
  if (!diagnosis) {
    return null;
  }

  return (
    <section className="rounded-xl border border-slate-800 bg-slate-900/50 p-6">
      <h2 className="text-sm font-semibold uppercase tracking-wide text-slate-400">
        Diagnosis
      </h2>

      <div className="mt-4 space-y-4">
        <div>
          <p className="text-xs font-medium uppercase text-slate-500">Root Cause</p>
          <p className="mt-1 text-lg font-semibold text-white">
            {diagnosis.root_cause}
          </p>
        </div>

        <div>
          <p className="text-xs font-medium uppercase text-slate-500">Explanation</p>
          <p className="mt-1 text-sm leading-relaxed text-slate-300">
            {diagnosis.explanation}
          </p>
        </div>

        <div>
          <p className="text-xs font-medium uppercase text-slate-500">Suggested Fix</p>
          <p className="mt-1 text-sm leading-relaxed text-slate-300">
            {diagnosis.fix}
          </p>
        </div>

        {diagnosis.kubectl_command && (
          <div>
            <p className="text-xs font-medium uppercase text-slate-500">Command</p>
            <code className="mt-1 block rounded-lg bg-slate-950 px-3 py-2 font-mono text-sm text-emerald-400">
              {diagnosis.kubectl_command}
            </code>
          </div>
        )}

        <div>
          <p className="text-xs font-medium uppercase text-slate-500">Confidence</p>
          <p className="mt-1 text-2xl font-bold text-blue-400">
            {diagnosis.confidence}%
          </p>
        </div>
      </div>
    </section>
  );
}
