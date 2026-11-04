import assert from "node:assert/strict";
import test from "node:test";
import { measureFinancePhase } from "./performance.ts";

test("phase timings preserve results without logging input or financial data", async () => {
  const info = console.info;
  const logs: string[] = [];
  console.info = (message) => logs.push(String(message));
  try {
    const result = await measureFinancePhase("provider", async () => ({
      private_input: "do not log this",
    }));
    assert.equal(result.private_input, "do not log this");
    const entry = JSON.parse(logs[0]);
    assert.deepEqual(Object.keys(entry).sort(), ["duration_ms", "event", "phase", "succeeded"]);
    assert.equal(entry.succeeded, true);
    assert.equal(entry.phase, "provider");
    assert.equal(logs[0].includes("do not log this"), false);
  } finally {
    console.info = info;
  }
});

test("failed phases preserve the original error and report failure", async () => {
  const info = console.info;
  const logs: string[] = [];
  const error = new Error("failure");
  console.info = (message) => logs.push(String(message));
  try {
    await assert.rejects(() => measureFinancePhase("commit", () => Promise.reject(error)),
      (caught) => caught === error);
    assert.equal(JSON.parse(logs[0]).succeeded, false);
  } finally {
    console.info = info;
  }
});
