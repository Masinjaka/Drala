# Feature verification

All items in `features.md` are implemented. The original batch and the newly
added envelope, stats, and active-page design requirements are covered below.

Additional verification on 2026-10-02:

- AdMob Advanced Native uses `google_mobile_ads` 8.0.0 with a themed medium
  native template after the home transaction list. The slot collapses
  until the ad loads. Debug/profile launch configurations use Google's test
  IDs; production IDs are passed with the four platform-specific dart defines
  documented in `admob.md`. Consent and required privacy choices are wired.
- Android debug and iOS simulator builds passed with the Ads plugin. A distinct
  dart-defined App ID was verified in the built Android merged manifest and
  iOS app `Info.plist`. Focused home and settings widget tests pass, including
  the ad privacy choices action. The iPhone simulator integration test loaded
  Google's iOS native test ad and rendered the home ad slot. Production ad
  serving still requires the owner's IDs and AdMob account configuration.
- The native ad validator's MediaView warning was addressed by replacing the
  small template with the medium template. The iOS container scales with the
  available width and keeps the template's 16:9 media area at least 120 points
  tall; Android uses its 350 dp template with a 190 dp media area. The iPhone
  simulator integration test verified the loaded ad and its responsive size.
- The iOS ad container's excess lower spacing was removed by sizing it to the
  medium template's visible content while retaining the recommended 320-point
  minimum and the full 16:9 media area.

- Drawer navigation opens envelope and stats carousels on the current month;
  notification deep links still pass their historical month. Navigation tests
  check both page defaults independently of the home calendar date.
- Editable amounts now use comma thousands grouping in shared transaction,
  envelope and wallet fields, including prefilled edits. Formatter, cursor,
  currency conversion and form-flow tests pass. The wallet editor reuses the
  envelope amount field and transaction name field.
- Dark mode uses a graphite page base between the old near-black and the
  light-mode home-banner gray, with stepped card surfaces and stronger
  theme-defined shimmer shades. Contrast and dark surface widget tests pass.
- The latest full Flutter run reports **303 passed, 10 failed**. The exact
  failing test names match the previous full run: nine older home layout,
  calendar, scroll and golden assertions, plus the notification error-toast
  timer. These are still failing and are not represented as a green suite.

- The remaining category, settings, transaction-sheet, AI category-priority and
  dark-mode requests are implemented. Active home, wallet, envelope, stats,
  category, settings, notification, receipt, plan, onboarding and profile-photo
  surfaces use theme-sourced foregrounds and surfaces. Focused dark-mode widget
  and color-contrast tests pass.
- The full Flutter suite reports **299 passed, 10 failed**. The failures are the
  pre-existing home/calendar/layout/golden assertions and notification-toast
  timer documented below; no new failing cases appeared in this pass.
- `node --test supabase/functions/process-finance-message/prompt_test.ts`
  passes. Focused static analysis of the latest screen edits found no issues.

| Requirement | Implementation and evidence |
| --- | --- |
| Shared manual transaction form | Shared editor surface, fields and actions; creation/edit/currency tests pass. |
| Input menu dismissal and typography | Outside-tap and theme typography widget tests pass. |
| Shared envelope form | Creation and editing use `AddEnvelopeSheet` and the transaction editor components. |
| Monthly funding | Same-wallet funding, retries and preserved history; SQL renewal, concurrency and rollback tests pass. |
| Reference envelope cards | Themed rounded surfaces and split progress; reviewed envelope golden passes. |
| Envelope calendar, year and header alignment | Shared month/year control, wheel picker and aligned button edges; cross-year paging tests pass. |
| Tap to edit and delete envelopes | Page-level tap/edit/delete and form-prefill tests pass; SQL tests verify atomic wallet adjustments and retained reversal records. |
| Envelope loading | Cached card names stay visible; only amounts/progress shimmer. Initial loads render card surfaces with placeholder values. Paging tests verify no spinner. |
| Stats calendar and year | Same month/year picker as envelopes; cross-year wheel test passes. |
| Stats paging and preload | Bounded three-month cache with in-flight deduplication; tests cover adjacent preloading, swipes, out-of-order responses and disposal. |
| Animated stats values/charts | Home digit animation and eased bar growth restart per month visit; amount privacy regression test passes. |
| Stats skeletons and reference design | Metric labels and chart title remain visible while values load; rounded filled surfaces and dashed chart grid; reviewed stats golden passes. |
| Compact controls | Shared 34-pixel visuals, 22-pixel icons and 44-pixel touch targets; control and back-navigation tests pass. |
| Active page theme consistency | Category, settings and its sub-pages, wallets, notifications and receipts use themed typography and shared detail headers. Category tabs pass in light and dark themes. |
| Active page motion/feedback/loading | Entry transitions, existing material tap feedback and value skeletons across lists; settings, receipt, notification and wallet tests pass. Reviewed wallet golden passes. |

Validation on 2026-10-01:

- Final affected-feature run: **48 passed**.
- Additional animated value/privacy checks: **3 passed**.
- Full suite before the final focused fixes: **285 passed, 11 failed**.
  All 11 failing cases also fail in the untouched `HEAD` baseline (14 failures).
  No newly failing cases remain. Known failures concern older home/calendar
  expectations, the home golden, and a notification error-toast timer.
- Static analysis has no new diagnostics; existing diagnostics remain.
- `bash test/database/run_monthly_envelope_tests.sh`: passed, including renewal
  concurrency, edit debit/refund, insufficient-funds rollback, ownership checks,
  and deletion of spent envelopes while retaining expense reversal records.
- Stats, envelope and wallet golden images were generated with app fonts and
  inspected. System emoji glyphs are unavailable in the headless golden renderer.
- Changed handwritten Dart and SQL files stay within 200 lines.

Supabase deployment:

All four migrations are applied to project `fqqpmzurvunhilnnhmtf`:

| Migration | Remote version |
| --- | --- |
| `add_monthly_envelope_renewal` | `20261001054752` |
| `renew_envelopes_before_expenses` | `20261001054806` |
| `serialize_monthly_envelope_funding` | `20261001054816` |
| `edit_funded_envelopes` | `20261001103616` |

Migration history and RPC permissions were verified. Both renewal call forms
passed authenticated SQL checks in a rolled-back transaction, and the
PostgREST schema cache was refreshed. The local ledger tests use an isolated
fixture; unrelated transaction routines are stubbed as described in
`monthly-envelopes.md`.
