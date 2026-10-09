import { ApiError } from "./errors.ts";

export async function fetchWithRetry(
  url: string,
  init: RequestInit,
  timeoutMs = 25_000,
): Promise<Response> {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), timeoutMs);
  try {
    let response = await fetch(url, { ...init, signal: controller.signal });
    if (response.status >= 500) {
      await new Promise((resolve) => setTimeout(resolve, 250));
      response = await fetch(url, { ...init, signal: controller.signal });
    }
    return response;
  } catch (error) {
    if (controller.signal.aborted) {
      throw new ApiError(
        "provider_timeout",
        "The AI provider took too long to respond. Please try again.",
        504,
      );
    }
    throw error;
  } finally {
    clearTimeout(timeout);
  }
}

export async function readJson(
  response: Response,
): Promise<Record<string, unknown>> {
  const text = await response.text();
  try {
    return asRecord(JSON.parse(text));
  } catch (_) {
    return { raw_error: text.slice(0, 1000) };
  }
}

export function requiredProviderEnv(name: string): string {
  const value = Deno.env.get(name);
  if (value) return value;
  throw new ApiError(
    "provider_not_configured",
    `${name} is not configured on the Edge Function.`,
    503,
  );
}

export function asRecord(value: unknown): Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value)
    ? value as Record<string, unknown>
    : {};
}

export function asNumber(value: unknown): number | undefined {
  return typeof value === "number" ? value : undefined;
}

export function invalidProviderResponse(): ApiError {
  return new ApiError(
    "invalid_model_response",
    "The AI provider returned an unreadable response.",
    502,
  );
}
