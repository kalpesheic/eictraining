import { redirect } from "next/navigation";

import { getInsforgeServerClient } from "@/lib/insforge-server";

export default async function HomePage() {
  const insforge = await getInsforgeServerClient();
  const { data } = await insforge.auth.getCurrentUser();

  if (data?.user) {
    redirect("/dashboard");
  }

  redirect("/login");
}
