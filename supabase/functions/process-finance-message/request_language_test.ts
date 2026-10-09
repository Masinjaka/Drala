import assert from "node:assert/strict";
import test from "node:test";
import { parseFinanceRequest } from "./request.ts";

for (const [code, name] of [
  ["mg", "Malagasy"],
  ["de", "German"],
  ["es", "Spanish"],
  ["it", "Italian"],
]) {
  test(`accepts ${code} as an AI output language`, async () => {
    const request = new Request("https://example.test", {
      method: "POST",
      body: JSON.stringify({
        message: "Lunch 100",
        target_date: "2026-01-01",
        timezone_offset_minutes: 0,
        output_language: code,
      }),
    });
    const parsed = await parseFinanceRequest(request);
    assert.equal(parsed.kind, "new");
    if (parsed.kind === "new") assert.equal(parsed.outputLanguage, name);
  });
}
