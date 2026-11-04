import assert from "node:assert/strict";
import test from "node:test";
import { completeRequest, loadContext } from "./database.ts";
import type { ModelResult } from "./types.ts";

test("the measured context loader keeps profile, wallet and conversation context", async () => {
  const rows: Record<string, unknown> = {
    categories: [{ name: "Food" }],
    category_presets: [{ name: "Transport" }],
    user: { currency_code: "MGA" },
    ai_chat_messages: [{ role: "assistant" }, { role: "user" }],
    wallets: [{ name: "Cash", balance: 900, currency_code: "MGA" }],
  };
  const admin = {
    from(table: string) {
      const result = Promise.resolve({ data: rows[table], error: null });
      const query: object = new Proxy({}, {
        get: (_, key) => key === "then"
          ? result.then.bind(result)
          : () => query,
      });
      return query;
    },
  } as Parameters<typeof loadContext>[0];
  const context = await loadContext(admin, "user", "request");
  assert.equal(context.currencyCode, "MGA");
  assert.deepEqual(context.categories, rows.categories);
  assert.deepEqual(context.wallets, rows.wallets);
  assert.deepEqual(context.history, [{ role: "user" }, { role: "assistant" }]);
});

test("the measured commit keeps the existing RPC and funding parameters", async () => {
  let rpc = "";
  let parameters: Record<string, unknown> | undefined;
  const admin = {
    rpc(name: string, input: Record<string, unknown>) {
      rpc = name;
      parameters = input;
      return Promise.resolve({ data: { entries: [] }, error: null });
    },
  } as unknown as Parameters<typeof completeRequest>[0];
  const result = {
    extraction: { transactions: [], transfers: [], categories_to_create: [] },
  } as unknown as ModelResult;
  assert.deepEqual(await completeRequest(admin, "user", "request", result, "cash", "2026-10-23"), { entries: [] });
  assert.equal(rpc, "complete_finance_request");
  assert.equal(parameters?.p_request_id, "request");
  assert.equal(parameters?.p_expense_wallet_id, "cash");
  assert.equal(parameters?.p_period_month, "2026-10-23");
});

test("database rejections are recorded as failed commit phases", async () => {
  const info = console.info;
  const logs: string[] = [];
  console.info = (message) => logs.push(String(message));
  const admin = {
    rpc: () => Promise.resolve({ data: null, error: { message: "insufficient_funds:10:0" } }),
  } as unknown as Parameters<typeof completeRequest>[0];
  const result = {
    extraction: { transactions: [], transfers: [], categories_to_create: [] },
  } as unknown as ModelResult;
  try {
    await assert.rejects(() => completeRequest(admin, "user", "request", result));
    assert.equal(JSON.parse(logs[0]).succeeded, false);
  } finally {
    console.info = info;
  }
});
