import type { SupabaseClient } from "npm:@supabase/supabase-js@2.57.4";
import type { AiContext } from "./types.ts";
import { ApiError } from "./errors.ts";
import { measureFinancePhase } from "./performance.ts";

export async function loadContext(
  admin: SupabaseClient,
  userId: string,
  requestId: string,
): Promise<AiContext> {
  return measureFinancePhase("context", async () => {
    const [categories, presets, profile, history, wallets] = await Promise.all([
      admin.from("categories")
        .select("name,emoji,color,icon_key,transaction_type")
        .eq("user_id", userId)
        .limit(100),
      admin.from("category_presets")
        .select("name,emoji,color,icon_key,transaction_type,aliases")
        .limit(100),
      admin.from("user")
        .select("currency_code")
        .eq("user_id", userId)
        .maybeSingle(),
      admin.from("ai_chat_messages")
        .select("role,content,created_at")
        .eq("user_id", userId)
        .neq("request_id", requestId)
        .order("created_at", { ascending: false })
        .limit(6),
      admin.from("wallets")
        .select("name,balance,currency_code")
        .eq("user_id", userId)
        .order("created_at"),
    ]);
    const error = categories.error ?? presets.error ?? profile.error ??
      history.error ?? wallets.error;
    if (error) throw new ApiError("database_error", error.message, 500);
    return {
      currencyCode: profile.data?.currency_code ?? "MGA",
      categories: categories.data ?? [],
      presets: presets.data ?? [],
      history: [...(history.data ?? [])].reverse(),
      wallets: wallets.data ?? [],
    };
  });
}
