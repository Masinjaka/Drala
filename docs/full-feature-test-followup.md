# Full feature test follow-up

Source: [Full feature test of the app](https://inky-powder-39e.notion.site/Full-feature-test-of-the-app-3fe60692acb980f58c86e2a7e13c81a4), read on 2026-10-22 and rechecked through its final language section. No additional findings were present on recheck.
Unchecked test scenarios in Notion are not automatically bugs. Explicit findings:

- [x] Put login/signup/guest choice before the final onboarding completion screen.
- [x] Preserve activity scroll position after editing an entry with the banner hidden.
- [x] Allow creating a category when editing a transaction.
- [x] Indicate truncated amount digits with an ellipsis before the currency.
- [ ] Add manual transfers between wallets. Implemented and tested locally; signed-in use awaits backend deployment approval.
- [x] Disable wallet confirmation when none has sufficient envelope funds; show a red explanation and a route to wallets (source sentence ends mid-request).
- [x] Explicit envelope funding wallet selection, default wallet preselected.
- [x] Create a category from envelope creation, including when none exists.
- [ ] Bulk envelope deletion. Implemented and tested locally; signed-in use awaits backend deployment approval.
- [x] Envelope deletion confirmation.
- [x] Specific envelope edit errors, including insufficient funds, with stable error codes.
- [x] Disable envelope save for zero amounts, including grouped zeros.
- [ ] Bulk wallet deletion. Implemented and tested locally; signed-in use awaits backend deployment approval.
- [x] Wallet deletion confirmation.
- [x] Explain that wallets in use cannot be deleted.
- [x] Keep emoji search visible above the keyboard.
- [x] Localize date roulette title and month names in Malagasy.

Existing checked scenarios include income creation/deletion, expense editing/
deletion, envelope deletion, wallet creation/editing, and category editing/
deletion. Preserve these paths throughout further work.

## Current implementation

Account setup now saves configuration, opens account choice, and then shows
completion. A persisted pending-completion flag survives guest restarts,
email-confirmation signup, and successful cloud sync. Existing completed guests
retain their previous routing behavior. Signed-in onboarding keeps its final
completion step.

The scroll reset was reproduced with one income entry: the edit keyboard
collapsed the underlying dashboard and clamped its offset from 180 to 0. The
page now retains its pre-keyboard layout while a modal keyboard is active,
including keyboard dismissal after the sheet closes. The asynchronous edit,
balance refresh, modal animations, and toast completion preserve the offset.

Manual entry has an income/expense/transfer control. Transfers explicitly choose
different source/destination wallets, convert display currency to MGA, reject
insufficient funds, persist history, and refresh wallet balances. They do not
change income or expense totals. Stable submission IDs prevent duplicate debits
on retry. The control also passes a small-phone/large-German-text layout check.

Wallet and envelope pages support multi-selection and one confirmation per
batch. Default wallets are protected. Guest batches run in one Drift
transaction, including their sync journals. Server batches are atomic RPCs;
envelope deletion reuses existing refund and expense-reversal logic. The
insufficient-funds chooser refreshes wallet balances before enabling selection. Wallet
locks use consistent ordering when refunds overlap transfers.

## Guest notification audit

The report names enabling notifications, delivery, reminders, reminder times,
and budget alerts under "Yet to test". These remain part of verification:

- Preference toggles and changed reminder times persist locally: widget test passes.
- Guest reminders now schedule locally using the device's IANA time zone and
  the saved hour/minute. The native daily schedule is refreshed after locale,
  time-zone, settings, or permission changes and cancelled during guest sync.
- Budget threshold alerts are stored atomically with expenses in a local inbox.
  Unchanged edits do not duplicate alerts. Pending delivery survives failures;
  stable native IDs make retries replace the same notification.
- Guest home reads the real local inbox. Marking a notification read is scoped
  to the guest; successful OS delivery does not mark the inbox item read.
- Permission denial keeps disabled preferences unchanged and shows the existing
  localized explanation. The background coordinator never prompts automatically.
- Database version 4 adds the notification table without replacing guest data.
- All **44 guest tests pass**, including threshold crossings, rollback, user
  isolation, old-database upgrades, permission denial, delivery retries,
  scheduling failure isolation, native Android scheduling arguments, DST, and
  app-resume/preference-change coordination.
- Android debug and iOS simulator builds pass. Visible device delivery remains
  unverified: the Computer Use simulator launch timed out. No integration test
  was claimed as passing.

Relevant sources: `GuestNotificationSettingsPage`, `GuestNotificationDelivery`,
`DeviceGuestNotificationGateway`, `GuestBudgetAlerts`, and
`GuestNotificationRepository`.

## Verification updated on 2026-10-23

- Original baseline: **421 passed, 45 failed** (`/tmp/drala-full-test.log`).
  Exact names are retained in [the baseline list](full-feature-test-baseline.txt).
- Latest full run: **465 passed, 44 failed** (`/tmp/drala-notifications-full-tests.jsonl`).
  Every failure matches the original baseline. The envelope edit test now
  matches the existing separate title/icon and explicitly confirms deletion.
  The suite is still not green; existing failures have not been relabeled as successes.
- Earlier focused feature run: **27 passed** (`/tmp/drala-current-focused.log`).
- Static analysis: **36 existing diagnostics**, with none introduced by the
  changes (`/tmp/drala-notifications-analysis-clean.log`).
- `bash test/database/run_manual_transfer_tests.sh`: passed, including anonymous
  permission checks, ownership, insufficient-funds rollback, idempotency and
  simultaneous retries (`/tmp/drala-transfer-sql-verified.log`).
- `bash test/database/run_bulk_deletion_tests.sh`: passed, including default/in-use
  wallet protection, batch rollback, duplicate IDs, refunds, expense reversal
  history, and overlapping transfers/refunds (`/tmp/drala-bulk-concurrency.log`).
- `git diff --check` passes. Changed/new handwritten Dart files stay within
  200 lines. Generated localization files keep the project's generated structure.
  Generated failure images were preserved in `/tmp/drala-test-artifacts-sabkl8b5`;
  tracked snapshots were restored. The final full-run images were also archived
  under `/tmp/drala-notification-test-artifacts-*` before restoring snapshots.
- Guest notification verification: **44 passed**
  (`/tmp/drala-guest-notifications-final-tests.log`).
- Android debug build passed (`/tmp/drala-guest-notifications-android-build.log`).
- iOS simulator build passed (`/tmp/drala-guest-notifications-ios-build.log`).
- Device delivery verification remains outstanding after the simulator launch
  tool timed out. The pre-existing iOS project change has been left intact.

## Deployment approval pending

Two additive migrations are ready:

- [Manual transfers](../supabase/migrations/20261027132335_manual_wallet_transfers.sql).
- [Atomic bulk deletion](../supabase/migrations/20261027132341_bulk_finance_deletion.sql).

The remote wallet/transfer schema and policies were inspected before preparing
these migrations. Automatic approval review rejected applying the transfer
migration because adding a balance-changing RPC requires explicit remote
deployment authorization. An asynchronous approval request covering both
migrations has been sent. **No approval has been received and neither migration
has been deployed.** A subsequent catalog query confirmed all three new RPCs
are absent remotely. Do not retry deployment through another tool without approval.

After approval, apply both migrations, refresh/verify PostgREST visibility,
verify authenticated/anonymous permissions, and retain migration history as evidence.
The live Notion report was rechecked through its final language section.
Remaining work is approved backend deployment and visible device delivery
verification. Full-suite baseline failures are recorded separately above.
