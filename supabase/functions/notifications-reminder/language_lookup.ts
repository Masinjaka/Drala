export type ReminderUser = {
  user_id: string;
  tokens: string[];
  local_date?: string;
  language_code?: string;
};

const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

export async function savedLanguages(
  users: ReminderUser[],
): Promise<Map<string, string>> {
  if (!supabaseUrl || !serviceKey || users.length === 0) return new Map();
  const ids = [...new Set(users.map((user) => user.user_id))];
  const languages = new Map<string, string>();
  for (let offset = 0; offset < ids.length; offset += 100) {
    const url = new URL("/rest/v1/notification_settings", supabaseUrl);
    url.searchParams.set("select", "user_id,language_code");
    url.searchParams.set("user_id", `in.(${ids.slice(offset, offset + 100).join(",")})`);
    const response = await fetch(url, {
      headers: { apikey: serviceKey, authorization: `Bearer ${serviceKey}` },
    });
    if (!response.ok) {
      if (response.status === 400) {
        const error = await response.json() as { message?: string };
        if (error.message?.includes("language_code")) return new Map();
      }
      throw new Error(`Language lookup failed: ${response.status}`);
    }
    const rows = await response.json() as {
      user_id: string;
      language_code: string;
    }[];
    for (const row of rows) languages.set(row.user_id, row.language_code);
  }
  return languages;
}
