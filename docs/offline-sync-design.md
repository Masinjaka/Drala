# Offline finance sync

## Model

Signed-in finance screens read and write a persistent, account-specific Drift
mirror. Guest storage stays separate. A first successful download is required
before an account can edit locally; offline startup thereafter uses its cache.
Logging out closes the account database; switching users never shares a ledger.

Every supported local mutation and its journal entry commit in the same SQLite
transaction. Upload batches contain at most 50 operations. Their UUID, original
payload and expected server revision persist before transmission. PostgreSQL
applies a batch atomically through the existing financial RPCs, and stores a
receipt. A retry after a lost response returns that receipt without repeating
financial effects. Only acknowledged operation IDs leave the outbox.

Cloud downloads use keyset pagination, then an account revision change feed with
deletions. Pages stage in SQLite and publish atomically only when the server
revision is unchanged and no local writes are pending. A separate pulled revision
survives a crash between upload acknowledgement and download. Canonical server
rows replace optimistic calculations after synchronization. Stable ID aliases
preserve references when older RPCs generate server IDs.

## Conflicts and access control

A newer cloud revision blocks an unacknowledged batch. Financial amounts never
silently use last-write-wins. The review sheet offers explicitly retrying reviewed
operations against the current revision, or confirmed removal of pending edits
and reloading the cloud ledger. Server financial validation still applies.
The revision check is account-wide and deliberately conservative: even unrelated
edits on another device can require review.

RPCs derive ownership from auth.uid(), validate allowed tables and payload bounds,
and use fixed search paths. Internal state, change feed, receipts and aliases have
RLS and no direct authenticated table access. Device code uses the ordinary
Supabase client, never a service-role key. An expired token plus a network error
preserves the session/cache; an actual authentication rejection pauses sync until
sign-in succeeds.

## Connectivity and supported work

Actual request failures detect DNS errors, sockets, timeouts and gateway failures;
a Wi-Fi connection alone is not treated as proof of internet access. Users receive
a localized offline toast and persistent status. Manual transactions, wallets,
categories, envelopes, cached statistics, profile and notification preferences use
local storage and queue changes. Exchange rates use previously cached rates;
unavailable conversions fall back to the base MGA currency.

AI entry processing, receipt recognition/gallery and account deletion require a
working cloud connection. Receipt image files are not downloaded into the mirror.
Monthly envelope renewal is authoritative on the server; reconnect applies it and
may require review if it overlaps pending edits. Device permission/token operations
still depend on the operating system and the remote notification service.

Sync runs on writes, foreground startup/resume, and foreground polling (45 seconds
when healthy). Transient failures retry with bounded exponential delays of 5–60
seconds. Timers pause in the background. This does not add OS background execution
or guarantee uploading while the app is terminated. Cached files remain in the
app sandbox until app data is removed; this change does not add database encryption.

## Backend rollout

Deploy the four migrations numbered 20261027132346 through 20261027132406 after
the existing ledger migrations and before releasing this app build. They add the
sync protocol, triggers, ownership checks and receipts. Existing rows are included
by the initial full download; no manual backfill is needed. The client cannot
initialize an account mirror against an old backend missing these RPCs.

Deployed through Supabase MCP on 2026-10-27 to project
`fqqpmzurvunhilnnhmtf`. Local filenames match the versions assigned by MCP:

| Version | Migration |
| --- | --- |
| 20261027132335 | manual_wallet_transfers (required prerequisite) |
| 20261027132341 | bulk_finance_deletion (required prerequisite) |
| 20261027132346 | offline_sync_state |
| 20261027132353 | offline_sync_ledger |
| 20261027132358 | offline_sync_dispatch |
| 20261027132406 | offline_sync_protocol |

Deployment inspection caught and corrected a category upsert referencing a
nonexistent remote `categories.updated_at` column. The regression fixture now
matches the hosted schema and covers updating an existing category.

Hosted checks verified all six history entries, ten enabled revision triggers,
RLS and revoked direct client access on all four internal tables, authenticated
access to the four public RPCs, and no client execution of private helpers.
All four RPCs rejected a missing authenticated user in a rollback-only smoke test.
Local PostgreSQL tests also passed, including concurrent duplicate retries.

The advisor's RLS-without-policies notices on the four sync tables are intentional:
clients use the ownership-checked RPCs. Existing advisories for legacy functions,
password protection and database patching remain outside this deployment.
`onboarding_wallet_presets` also has RLS disabled; a direct privilege check
confirmed anon/authenticated have no SELECT, INSERT or UPDATE access. See
[Supabase RLS guidance](https://supabase.com/docs/guides/database/postgres/row-level-security).

Check migration history before future deployments.
Do not delete receipts or aliases casually: queued devices may retry old batches.
The change feed stores the latest change per entity; tombstones must remain while
offline devices can still return.

## Verification

- `fvm flutter test test/features/offline test/features/guest/data test/core/currency`
- `fvm flutter test test/app_auth_stream_error_test.dart test/core/navigation/auth_router_refresh_test.dart`
- `bash test/database/run_offline_sync_tests.sh` (Docker; isolated PostgreSQL 16)
- `fvm flutter analyze --no-pub`

Coverage includes local write/outbox atomicity, initial download gating, ownership,
interrupted downloads, changes arriving during a download, tombstones, durable
restart after a lost acknowledgement, reconnect, conflicts, and real PostgreSQL
ledger replay and duplicate receipt handling. Tests do not access production data.

## Design references

- [Flutter offline-first repositories](https://docs.flutter.dev/app-architecture/design-patterns/offline-first)
- [Drift transactions](https://drift.simonbinder.eu/dart_api/transactions/)
- [Supabase row-level security](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [Connectivity limitations](https://pub.dev/packages/connectivity_plus)
