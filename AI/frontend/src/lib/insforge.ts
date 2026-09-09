import { createBrowserClient } from "@insforge/sdk/ssr";

export function getInsforgeBrowserClient() {
  return createBrowserClient({
    refreshUrl: "/api/auth/refresh",
  });
}

export function investigationChannel(investigationId: string) {
  return `investigation:${investigationId}`;
}
