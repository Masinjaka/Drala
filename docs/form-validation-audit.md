# Inline form validation

Missing or invalid form values are shown under their fields when saving.
Operational failures (storage, network, permissions, insufficient funds) keep
existing toast handling. Optional descriptions, images, goal dates, and initial
wallet balances remain optional. Category emoji and color retain their defaults.

## Coverage

- Income/expense creation and editing: required title, positive amount, category.
  Switching transaction type clears an incompatible category.
- Envelopes: required name, positive amount, category. Save validates instead of
  silently disabling missing fields. Categories remain saved after cancellation.
- Categories and subcategories: required names; default appearance is accepted.
- Wallet creation/editing: required name, non-negative balance; an empty balance
  means zero. Obsolete disabled-button listeners were removed.
- Manual transfers: positive amount and required wallet selectors. Existing
  sufficient-funds, distinct-wallet, and currency checks remain in place.
- Login and forgot password: existing Form validators now provide readable,
  whitespace-aware required-field messages through the shared text input.
- Signup: username/email/password validation; password confirmation mismatch is
  inline. Legal consent continues to gate account creation.
- Password reset: a complete six-digit code, valid new password, matching
  confirmation. Code and password errors appear below the corresponding input.
- Change password: current password required; new password rules, difference
  from current password, and confirmation match are validated inline.
- Profile editing and feedback: existing Form validation uses the shared readable
  required-field behavior; username validation is explicitly registered.
- Older transaction dialogs/pages: category, amount, and split subcategory rows
  validate before submission, avoiding missing-field result toasts.
- Budgets, goal creation/editing, and goal top-ups: required names/selections and
  positive amounts use inline validation. Default budget periods and optional
  goal dates remain valid without changes.
- Onboarding selection controls and searches are not new mandatory text fields.
  Destructive-action confirmation safeguards remain unchanged.

## Shared behavior

`FieldValidators`, `ValidatedSelection`, and `ValidatedInput` provide localized
validation without data-layer changes. Text validators use Form/TextFormField;
non-text selectors register with the same Form. Corrected values clear their
errors. All six supported languages have readable fallback validation messages.

Transaction-style sheets can scroll as messages increase their content height.
Large legacy form files were split into focused parts to respect the 200-line
limit. New UI text/color styles come from the existing application theme.

## Verification

Tests in `test/core/forms` cover missing fields, correction and successful saves,
light/dark themes, income/expense category editing, password/reset forms, budgets,
goals, continued operational error toasts, and small-phone touch scrolling.
- New cross-form tests: **14 pass**; focused validation/scrolling run: **15 pass**
  (`/tmp/drala-forms-final-focused-tests.log`).
- Full suite: **497 passed, 44 existing failures**. No new failing test
  names compared with the recorded baseline (`/tmp/drala-forms-complete-tests.jsonl`).
- Analysis: **36 existing diagnostics**, with no new ones
  (`/tmp/drala-forms-verified-clean-analysis.log`).
- Changed handwritten Dart files are within 200 lines; `git diff --check` passes.
- Generated failure images were preserved in `/tmp/drala-form-test-artifacts-d3lfo_ia`;
  tracked snapshots were restored.
