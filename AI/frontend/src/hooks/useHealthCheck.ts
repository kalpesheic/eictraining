import { useQuery } from "@tanstack/react-query";

import { checkHealth } from "@/services/api";

export function useHealthCheck() {
  return useQuery({
    queryKey: ["health"],
    queryFn: checkHealth,
  });
}
