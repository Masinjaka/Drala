import assert from "node:assert/strict";
import test from "node:test";
import { ApiError } from "./errors.ts";
import { fetchWithRetry, readJson } from "./provider_http.ts";

test("the provider deadline covers a response body that stalls after headers", async () => {
  const originalFetch = globalThis.fetch;
  globalThis.fetch = ((_url, init) => Promise.resolve(new Response(
    new ReadableStream({
      start(controller) {
        init?.signal?.addEventListener("abort", () => {
          controller.error(new DOMException("Aborted", "AbortError"));
        }, { once: true });
      },
    }),
  ))) as typeof fetch;
  const deadline = new AbortController();
  // A failing implementation must fail this test, rather than hang the suite.
  const guard = setTimeout(() => deadline.abort(), 200);
  try {
    await assert.rejects(
      () => Promise.race([
        fetchWithRetry("https://provider.test", {}, 10).then(readJson),
        new Promise((_, reject) => deadline.signal.addEventListener("abort", () =>
          reject(new Error("Response body outlived the provider deadline")))),
      ]),
      (error: unknown) => error instanceof ApiError && error.code === "provider_timeout",
    );
  } finally {
    clearTimeout(guard);
    globalThis.fetch = originalFetch;
  }
});

test("buffering preserves a successful provider JSON response and status", async () => {
  const originalFetch = globalThis.fetch;
  globalThis.fetch = (() => Promise.resolve(new Response('{"ok":true}', {
    status: 200, headers: { "content-type": "application/json" },
  }))) as typeof fetch;
  try {
    const response = await fetchWithRetry("https://provider.test", {}, 100);
    assert.equal(response.status, 200);
    assert.equal(response.headers.get("content-type"), "application/json");
    assert.deepEqual(await readJson(response), { ok: true });
  } finally {
    globalThis.fetch = originalFetch;
  }
});

test("a retry cancels the failed response before reading the replacement", async () => {
  const originalFetch = globalThis.fetch;
  let attempts = 0;
  let cancelled = false;
  globalThis.fetch = (() => {
    attempts++;
    if (attempts === 1) {
      return Promise.resolve(new Response(new ReadableStream({
        cancel() { cancelled = true; },
      }), { status: 503 }));
    }
    assert.equal(cancelled, true);
    return Promise.resolve(new Response('{"ok":true}'));
  }) as typeof fetch;
  try {
    assert.deepEqual(await readJson(await fetchWithRetry("https://provider.test", {}, 500)), { ok: true });
    assert.equal(attempts, 2);
  } finally {
    globalThis.fetch = originalFetch;
  }
});

test("the shared deadline also stops a retry backoff", async () => {
  const originalFetch = globalThis.fetch;
  let attempts = 0;
  globalThis.fetch = (() => {
    attempts++;
    return Promise.resolve(new Response("unavailable", { status: 503 }));
  }) as typeof fetch;
  try {
    await assert.rejects(() => fetchWithRetry("https://provider.test", {}, 10),
      (error: unknown) => error instanceof ApiError && error.code === "provider_timeout");
    assert.equal(attempts, 1);
  } finally {
    globalThis.fetch = originalFetch;
  }
});
