import assert from "node:assert/strict";
import test from "node:test";
import { ApiError } from "./errors.ts";
import { fetchWithRetry } from "./provider_http.ts";

test("aborts a stalled AI provider request", async () => {
  const originalFetch = globalThis.fetch;
  globalThis.fetch = ((_url, init) =>
    new Promise<Response>((_resolve, reject) => {
      init?.signal?.addEventListener(
        "abort",
        () => reject(new DOMException("Aborted", "AbortError")),
        { once: true },
      );
    })) as typeof fetch;

  try {
    await assert.rejects(
      () => fetchWithRetry("https://provider.test", {}, 5),
      (error: unknown) =>
        error instanceof ApiError && error.code === "provider_timeout",
    );
  } finally {
    globalThis.fetch = originalFetch;
  }
});
