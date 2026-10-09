export type PendingAlert = {
  id: string;
  envelope_id: string;
  notification_type: string;
  envelope_name: string;
  amount: number;
};
export type AlertBatch = { alerts: PendingAlert[]; languageCode: string };

const baseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const anonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
const levels = ["warning", "reached", "exceeded"];
const messages: Record<string, [string, string][]> = {
  en: [
    ["Budget almost reached", "The {name} budget is almost spent."],
    ["Budget reached", "The {name} budget has been reached."],
    ["Budget exceeded", "You exceeded the {name} budget."],
  ],
  fr: [
    ["Budget bientôt atteint", "Le budget {name} est presque épuisé."],
    ["Budget atteint", "Le budget {name} est épuisé."],
    ["Budget dépassé", "Vous avez dépassé {name}."],
  ],
  mg: [
    ["Tetibola efa ho lany", "Efa ho lany ny tetibola {name}."],
    ["Tetibola lany", "Lany ny tetibola {name}."],
    ["Tetibola nihoatra", "Nihoatra ny tetibola {name} ianao."],
  ],
  de: [
    ["Budget fast erreicht", "Das Budget für {name} ist fast aufgebraucht."],
    ["Budget erreicht", "Das Budget für {name} ist aufgebraucht."],
    ["Budget überschritten", "Du hast das Budget für {name} überschritten."],
  ],
  es: [
    ["Presupuesto casi alcanzado", "El presupuesto de {name} está casi agotado."],
    ["Presupuesto alcanzado", "Se ha alcanzado el presupuesto de {name}."],
    ["Presupuesto superado", "Has superado el presupuesto de {name}."],
  ],
  it: [
    ["Budget quasi raggiunto", "Il budget di {name} è quasi esaurito."],
    ["Budget raggiunto", "Il budget di {name} è stato raggiunto."],
    ["Budget superato", "Hai superato il budget di {name}."],
  ],
};

function restUrl(table: string, params: Record<string, string>): URL {
  const url = new URL(`/rest/v1/${table}`, baseUrl);
  for (const [key, value] of Object.entries(params)) {
    url.searchParams.set(key, value);
  }
  return url;
}

function serviceHeaders(): Record<string, string> {
  return { apikey: serviceKey, authorization: `Bearer ${serviceKey}` };
}

async function rows<T>(url: URL): Promise<T[]> {
  const response = await fetch(url, { headers: serviceHeaders() });
  if (!response.ok) throw new Error(`Database request failed: ${response.status}`);
  return await response.json() as T[];
}

export async function authenticatedUser(req: Request): Promise<string | null> {
  const token = req.headers.get("authorization");
  if (!token?.startsWith("Bearer ") || !baseUrl || !anonKey) return null;
  const response = await fetch(new URL("/auth/v1/user", baseUrl), {
    headers: { apikey: anonKey, authorization: token },
  });
  if (!response.ok) return null;
  const user = await response.json() as { id?: string };
  return user.id ?? null;
}

export async function pendingAlerts(userId: string): Promise<AlertBatch> {
  if (!baseUrl || !serviceKey) throw new Error("Missing Supabase service settings");
  const settings = await rows<{
    notifications_enabled: boolean;
    warnings_enabled: boolean;
    language_code: string;
  }>(restUrl("notification_settings", {
    select: "notifications_enabled,warnings_enabled,language_code",
    user_id: `eq.${userId}`,
  }));
  if (settings.length &&
      (!settings[0].notifications_enabled || !settings[0].warnings_enabled)) {
    return { alerts: [], languageCode: settings[0].language_code };
  }
  const alerts = await rows<PendingAlert>(restUrl("finance_notifications", {
    select: "id,envelope_id,notification_type,envelope_name,amount",
    user_id: `eq.${userId}`,
    push_sent_at: "is.null",
    is_read: "eq.false",
    order: "created_at.asc",
    limit: "50",
  }));
  return { alerts, languageCode: settings[0]?.language_code ?? "fr" };
}

export async function deviceTokens(userId: string): Promise<string[]> {
  const devices = await rows<{ token: string }>(restUrl("device_tokens", {
    select: "token", user_id: `eq.${userId}`, enabled: "eq.true",
  }));
  return [...new Set(devices.map((device) => device.token))];
}

export async function markAlertSent(id: string): Promise<void> {
  const response = await fetch(restUrl("finance_notifications", { id: `eq.${id}` }), {
    method: "PATCH",
    headers: { ...serviceHeaders(), "content-type": "application/json" },
    body: JSON.stringify({ push_sent_at: new Date().toISOString() }),
  });
  if (!response.ok) throw new Error(`Marking alert sent failed: ${response.status}`);
}

export function alertMessage(
  alert: PendingAlert,
  languageCode = "fr",
): { title: string; body: string; level: string } {
  const index = switchAlertLevel(alert.notification_type);
  const [title, template] = (messages[languageCode] ?? messages.fr)[index];
  const level = levels[index];
  return { title, body: template.replace("{name}", alert.envelope_name), level };
}

function switchAlertLevel(type: string): number {
  switch (type) {
    case "envelope_near_limit": return 0;
    case "envelope_limit_reached": return 1;
    default: return 2;
  }
}
