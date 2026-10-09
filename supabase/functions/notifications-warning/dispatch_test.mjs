import assert from "node:assert/strict";
import test from "node:test";

const environment = {
  SUPABASE_URL: "https://project.example",
  SUPABASE_SERVICE_ROLE_KEY: "service-test-key",
  SUPABASE_ANON_KEY: "anon-test-key",
};
globalThis.Deno = { env: { get: (name) => environment[name] } };

const dispatch = await import("./dispatch.ts");

test("formats all three envelope warning levels", () => {
  for (const [type, level] of [
    ["envelope_near_limit", "warning"],
    ["envelope_limit_reached", "reached"],
    ["envelope_overspent", "exceeded"],
  ]) {
    const message = dispatch.alertMessage({
      id: "alert", envelope_id: "envelope", notification_type: type,
      envelope_name: "Food", amount: 10,
    }, "de");
    assert.equal(message.level, level);
    assert.match(message.body, /Food/);
  }
});

test("loads only pending alerts for the authenticated user", async (t) => {
  const calls = [];
  globalThis.fetch = async (url, options) => {
    calls.push({ url: new URL(url), options });
    if (String(url).includes("notification_settings")) {
      return Response.json([{
        notifications_enabled: true, warnings_enabled: true,
        language_code: "de",
      }]);
    }
    return Response.json([{
      id: "alert", envelope_id: "envelope",
      notification_type: "envelope_near_limit",
      envelope_name: "Food", amount: 10,
    }]);
  };
  t.after(() => { delete globalThis.fetch; });

  const batch = await dispatch.pendingAlerts("user-1");
  assert.equal(batch.alerts.length, 1);
  assert.equal(batch.languageCode, "de");
  assert.equal(calls[1].url.searchParams.get("user_id"), "eq.user-1");
  assert.equal(calls[1].url.searchParams.get("push_sent_at"), "is.null");
  assert.equal(calls[1].url.searchParams.get("is_read"), "eq.false");
  assert.equal(calls[1].options.headers.apikey, "service-test-key");
});

test("does not load alerts when budget warnings are disabled", async (t) => {
  let calls = 0;
  globalThis.fetch = async () => {
    calls += 1;
    return Response.json([{
      notifications_enabled: true,
      warnings_enabled: false,
      language_code: "es",
    }]);
  };
  t.after(() => { delete globalThis.fetch; });

  const batch = await dispatch.pendingAlerts("user-1");
  assert.equal(batch.alerts.length, 0);
  assert.equal(calls, 1);
});
