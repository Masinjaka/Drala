import assert from "node:assert/strict";
import test from "node:test";

const environment = {
  SUPABASE_URL: "https://project.example",
  SUPABASE_SERVICE_ROLE_KEY: "service-test-key",
};
globalThis.Deno = { env: { get: (name) => environment[name] } };

const { savedLanguages } = await import("./language_lookup.ts");

test("loads saved reminder language for each user in one request", async (t) => {
  const calls = [];
  globalThis.fetch = async (url, options) => {
    calls.push({ url: new URL(url), options });
    return Response.json([
      { user_id: "first", language_code: "mg" },
      { user_id: "second", language_code: "de" },
    ]);
  };
  t.after(() => { delete globalThis.fetch; });

  const languages = await savedLanguages([
    { user_id: "first", tokens: ["a"] },
    { user_id: "second", tokens: ["b"] },
  ]);
  assert.equal(calls.length, 1);
  assert.equal(calls[0].url.searchParams.get("user_id"), "in.(first,second)");
  assert.equal(calls[0].options.headers.apikey, "service-test-key");
  assert.equal(languages.get("first"), "mg");
  assert.equal(languages.get("second"), "de");
});

test("batches large reminder groups", async (t) => {
  let calls = 0;
  globalThis.fetch = async () => {
    calls += 1;
    return Response.json([]);
  };
  t.after(() => { delete globalThis.fetch; });

  const users = Array.from({ length: 101 }, (_, index) => ({
    user_id: `user-${index}`,
    tokens: ["token"],
  }));
  await savedLanguages(users);
  assert.equal(calls, 2);
});
