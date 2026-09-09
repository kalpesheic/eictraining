import { cookies } from "next/headers";
import { createServerClient } from "@insforge/sdk/ssr";

export async function getInsforgeServerClient() {
  return createServerClient({
    cookies: await cookies(),
  });
}
