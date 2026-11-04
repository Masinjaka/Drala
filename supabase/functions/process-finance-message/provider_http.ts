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
      await response.body?.cancel();
      await waitForRetry(controller.signal);
      response = await fetch(url, { ...init, signal: controller.signal });
    }
    // Keep the same deadline until the complete provider payload arrives.
    // fetch() resolves at the headers; clearing it there leaves body reads unbounded.
    const body = response.body === null ? null : await response.arrayBuffer();
    return new Response(body, {
      status: response.status,
      statusText: response.statusText,
      headers: response.headers,
    });
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

function waitForRetry(signal: AbortSignal): Promise<void> {
  return new Promise((resolve, reject) => {
    signal.throwIfAborted();
    const abort = () => {
      clearTimeout(timer);
      reject(signal.reason);
    };
    const timer = setTimeout(() => {
      signal.removeEventListener("abort", abort);
      resolve();
    }, 250);
    signal.addEventListener("abort", abort, { once: true });
  });
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
