"use client";

import type { InvestigationRecord } from "@/types";

interface InvestigationHistoryProps {
  records: InvestigationRecord[];
  isLoading: boolean;
}

function formatTimestamp(value: string) {
  return new Date(value).toLocaleString(undefined, {
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

function statusColor(status: string) {
  switch (status) {
    case "completed":
      return "text-emerald-400";
    case "failed":
      return "text-red-400";
    default:
      return "text-amber-400";
  }
}

export function InvestigationHistory({
  records,
  isLoading,
}: InvestigationHistoryProps) {
  return (
    <section className="rounded-xl border border-slate-800 bg-slate-900/50 p-6">
      <h2 className="text-sm font-semibold uppercase tracking-wide text-slate-400">
        Recent Investigations
      </h2>

      {isLoading ? (
        <p className="mt-4 text-sm text-slate-500">Loading history…</p>
      ) : records.length === 0 ? (
        <p className="mt-4 text-sm text-slate-500">
          No investigations yet. Click Investigate Cluster to start.
        </p>
      ) : (
        <div className="mt-4 overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead>
              <tr className="border-b border-slate-800 text-xs uppercase text-slate-500">
                <th className="pb-2 pr-4 font-medium">Timestamp</th>
                <th className="pb-2 pr-4 font-medium">Root Cause</th>
                <th className="pb-2 pr-4 font-medium">Namespace</th>
                <th className="pb-2 pr-4 font-medium">Confidence</th>
                <th className="pb-2 font-medium">Status</th>
              </tr>
            </thead>
            <tbody>
              {records.map((record) => (
                <tr
                  key={record.id}
                  className="border-b border-slate-800/60 text-slate-300"
                >
                  <td className="py-3 pr-4 text-slate-400">
                    {formatTimestamp(record.created_at ?? record.timestamp)}
                  </td>
                  <td className="py-3 pr-4 font-medium text-white">
                    {record.root_cause ?? "—"}
                  </td>
                  <td className="py-3 pr-4">{record.namespace ?? "—"}</td>
                  <td className="py-3 pr-4">
                    {record.confidence != null ? `${record.confidence}%` : "—"}
                  </td>
                  <td className={`py-3 capitalize ${statusColor(record.status)}`}>
                    {record.status}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </section>
  );
}
