import { reminderMessage } from "./messages.ts";

Deno.test("daily reminder follows each supported language", () => {
  for (const code of ["en", "fr", "mg", "de", "es", "it"]) {
    const message = reminderMessage(code);
    if (!message.title || !message.body) {
      throw new Error(`Missing ${code} reminder`);
    }
  }
  if (reminderMessage("unknown") !== reminderMessage("en")) {
    throw new Error("Unknown language did not fall back to English");
  }
});
