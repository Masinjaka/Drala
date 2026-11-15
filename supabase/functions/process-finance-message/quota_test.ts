import assert from "node:assert/strict";
import test from "node:test";
import { quotaSnapshot, reserveRequest } from "./database.ts";
import { quotaError } from "./response.ts";

test("reservation uses five credits and reports exhaustion without provider work", async () => {
  const admin = {
    rpc(_name: string, input: Record<string, unknown>) {
      assert.equal(input.p_daily_limit, 5);
      return Promise.resolve({ data: { allowed: false, code: "daily_limit_exceeded", remaining: 0 }, error: null });
    },
  } as unknown as Parameters<typeof reserveRequest>[0];
  const result = await reserveRequest(admin, "test", "test", "test", "test");
  const error = quotaError(result);
  assert.equal(error.status, 429);
  assert.match(error.message, /5 AI credits/);
});

for (const [tier, end, count, remaining] of [
  ["free", null, 0, 5], ["free", null, 4, 1], ["free", null, 8, 0],
  ["pro", null, 8, null], ["pro", "2000-01-01", 4, 1],
] as const) {
  test(`quota snapshot ${tier}, expiry ${end}, usage ${count}`, async () => {
    const admin = {
      from(table: string) {
        const response = Promise.resolve(table === "account_plans"
          ? { data: { tier, status: "active", current_period_end: end }, error: null }
          : { count, error: null });
        const query: object = new Proxy({}, {
          get: (_, key) => key === "then" ? response.then.bind(response) : () => query,
        });
        return query;
      },
    } as unknown as Parameters<typeof quotaSnapshot>[0];
    const snapshot = await quotaSnapshot(admin, "test");
    assert.equal(snapshot.remaining, remaining);
    assert.equal(snapshot.unlimited, remaining === null);
  });
}
