#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
container="drala-offline-sync-$$"
trap 'docker rm -f "$container" >/dev/null 2>&1 || true' EXIT
docker run --detach --rm --name "$container" -e POSTGRES_PASSWORD=local-test-only postgres:16-alpine >/dev/null
for attempt in {1..30}; do
  if docker exec "$container" pg_isready -U postgres >/dev/null 2>&1; then break; fi
  sleep 1
done
for sql in test/database/offline_sync_fixture.sql \
 supabase/migrations/20260718090300_add_funded_envelope_ledger.sql \
 supabase/migrations/20261005090000_allow_negative_expense_wallet.sql \
 supabase/migrations/20260719090100_add_multi_wallet_manual_entries.sql \
 supabase/migrations/20260724090100_edit_finance_entries.sql \
 supabase/migrations/20261001090000_add_monthly_envelope_renewal.sql \
 supabase/migrations/20261001090100_renew_envelopes_before_expenses.sql \
 supabase/migrations/20261001090200_serialize_monthly_envelope_funding.sql \
 supabase/migrations/20261001090300_edit_funded_envelopes.sql \
 supabase/migrations/20261005090000_allow_negative_expense_wallet.sql \
 supabase/migrations/20260726100200_reverse_envelope_overspending.sql \
 supabase/migrations/20261009090200_edit_income_by_difference.sql \
 supabase/migrations/20261027132335_manual_wallet_transfers.sql \
 supabase/migrations/20261027132341_bulk_finance_deletion.sql \
 supabase/migrations/20261027132346_offline_sync_state.sql \
 supabase/migrations/20261027132353_offline_sync_ledger.sql \
 supabase/migrations/20261027132358_offline_sync_dispatch.sql \
 supabase/migrations/20261027132406_offline_sync_protocol.sql \
 test/database/offline_sync_test.sql; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < "$sql"
done
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 <<'SQL'
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',false);
create table test_sync_revision as select public.offline_sync_revision() revision;
SQL
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < test/database/offline_sync_concurrent_retry.sql &
first_worker=$!
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < test/database/offline_sync_concurrent_retry.sql &
second_worker=$!
wait "$first_worker"
wait "$second_worker"
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 <<'SQL'
do $$ begin
 if (select count(*) from public."transaction" where title='Concurrent expense')<>1 or
    (select count(*) from public.offline_batch_receipts where batch_id='70000000-0000-0000-0000-000000000099')<>1
 then raise exception 'concurrent retries duplicated an operation'; end if;
end $$;
SQL
