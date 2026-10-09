import assert from "node:assert/strict";
import test from "node:test";
import { buildPrompts } from "./prompt.ts";

test("sends manually added categories and presets with user priority", () => {
  const prompts = buildPrompts("Lunch", {
    currencyCode: "MGA",
    categories: [{ name: "Meals out", transaction_type: "expense" }],
    presets: [{ name: "Food", transaction_type: "expense" }],
    history: [],
    wallets: [],
  }, "2026-10-02T12:00:00Z", "Indian/Antananarivo", "2026-10-02");

  const user = JSON.parse(prompts.user);
  assert.deepEqual(user.user_categories, [
    { name: "Meals out", transaction_type: "expense" },
  ]);
  assert.deepEqual(user.category_presets, [
    { name: "Food", transaction_type: "expense" },
  ]);
  assert.match(prompts.system, /Prefer a fitting user category/);
});

test("requests localized text while preserving supplied category names", () => {
  const prompts = buildPrompts("Lunch", {
    currencyCode: "MGA",
    categories: [{ name: "Meals out", transaction_type: "expense" }],
    presets: [],
    history: [],
    wallets: [],
  }, "2026-10-02T12:00:00Z", "Indian/Antananarivo", "2026-10-02", "Malagasy");

  assert.match(prompts.system, /in Malagasy/);
  assert.match(prompts.system, /exact names of supplied categories/);
});
