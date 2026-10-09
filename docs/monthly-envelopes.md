# Monthly envelopes

Apply these migrations in order before releasing the updated application:

1. `20261001090000_add_monthly_envelope_renewal.sql`
2. `20261001090100_renew_envelopes_before_expenses.sql`
3. `20261001090200_serialize_monthly_envelope_funding.sql`

Applied to Supabase project `fqqpmzurvunhilnnhmtf` on 2026-10-01 through MCP.
Remote migration versions are `20261001054752`, `20261001054806`, and
`20261001054816`, respectively. Both renewal signatures passed authenticated
SQL checks; permissions were verified and the API schema cache was refreshed.

Ordinary wallet and envelope reads tolerate a missing renewal RPC during
rollout. Monthly creation still requires the migrations; it is never silently
converted to one-off funding.

The optional monthly setting funds a fresh envelope from the original wallet.
Renewal is materialized on wallet/envelope reads or expense processing, using
the database's current calendar month. Previous months retain their amounts
and spending history. Missed months are not backfilled or charged.

If the original wallet cannot cover the full amount, the schedule remains
pending. Subsequent reads, wallet top-ups, or expense processing retry it.
Other wallets are never used automatically. Deleting the active envelope stops
its schedule. One-off envelopes retain their existing behavior.

Renewal and funding use a shared per-user transaction lock. The monthly
uniqueness constraint and atomic wallet debit prevent duplicate funding.
Existing transaction accounting functions remain behind compatibility wrappers.

Run isolated PostgreSQL checks with Docker:

```sh
bash test/database/run_monthly_envelope_tests.sh
```

The test harness runs the real funding/renewal migrations against a minimal
ledger fixture; unrelated transaction routines are stubbed. It checks history,
insufficient funds, retries, duplicate requests, concurrent renewal, rollback,
and RPC access restrictions. It does not replace a staging migration check
against a complete Supabase database.

UI and repository verification includes manual creation/editing, currency
conversion, the monthly option, menu dismissal, category selection, month/year
navigation, the envelope visual baseline, and wallet refresh ordering.

## Editing and deleting

`20261001090300_edit_funded_envelopes.sql` was applied through MCP on 2026-10-01.
Edits debit or refund the budget difference from the original wallet atomically.
The budget cannot fall below the amount already consumed from the envelope;
previous wallet-funded overspending remains recorded. Editing a historical
envelope cannot replace a later month's renewal schedule.

Deletion refunds unspent funds and retains transaction reversal records, so a
later expense deletion can still refund the original funding wallet. The SQL
test harness verifies edits, insufficient funds, ownership, and spent deletion.
