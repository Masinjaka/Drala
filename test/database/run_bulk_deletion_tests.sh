#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
container="drala-bulk-deletion-$$"
trap 'docker rm -f "$container" >/dev/null 2>&1 || true' EXIT
docker run --detach --rm --name "$container" \
  -e POSTGRES_PASSWORD=local-test-only postgres:16-alpine >/dev/null
for attempt in {1..30}; do
  if docker exec "$container" pg_isready -U postgres >/dev/null 2>&1; then break; fi
  sleep 1
done
for sql in test/database/monthly_envelope_fixture.sql \
  supabase/migrations/20260718090300_add_funded_envelope_ledger.sql \
  supabase/migrations/20261001090000_add_monthly_envelope_renewal.sql \
  supabase/migrations/20261001090100_renew_envelopes_before_expenses.sql \
  supabase/migrations/20261001090200_serialize_monthly_envelope_funding.sql \
  test/database/envelope_edit_fixture.sql \
  supabase/migrations/20261001090300_edit_funded_envelopes.sql \
  supabase/migrations/20261027132341_bulk_finance_deletion.sql \
  test/database/bulk_deletion_test.sql; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < "$sql"
done
for sql in test/database/bulk_concurrency_setup.sql \
  supabase/migrations/20261027132335_manual_wallet_transfers.sql; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < "$sql"
done
# Hold A first, then overlap a transfer with a B-before-A envelope selection.
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 <<'SQL' &
begin;
set local lock_timeout='4s';
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000003',true);
select 1 from public.wallets where name='Concurrent A' for update;
select pg_sleep(1);
select public.create_manual_wallet_transfer(
 '60000000-0000-0000-0000-000000000001',
 '30000000-0000-0000-0000-000000000001',
 '30000000-0000-0000-0000-000000000002',100,now(),'Concurrent');
commit;
SQL
transfer_pid=$!
for attempt in {1..30}; do
  held=$(docker exec "$container" psql -U postgres -Atc \
    "select count(*) from pg_locks where relation='public.wallets'::regclass and mode='RowShareLock'")
  if [[ "$held" != 0 ]]; then break; fi
  sleep .05
done
if [[ "$held" == 0 ]]; then
  wait "$transfer_pid"
  echo 'Transfer did not acquire its wallet lock in time' >&2
  exit 1
fi
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 <<'SQL'
set lock_timeout='4s';
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000003',false);
select public.delete_funded_envelopes(array[
 '50000000-0000-0000-0000-000000000001'::uuid,
 '50000000-0000-0000-0000-000000000002'::uuid]);
SQL
wait "$transfer_pid"
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 <<'SQL'
do $$ begin
 if (select balance from public.wallets where name='Concurrent A') is distinct from 900 or
    (select balance from public.wallets where name='Concurrent B') is distinct from 1100 or
    (select count(*) from public.wallet_transfers) <> 1 or
    exists(select 1 from public.envelopes where name in ('A','B')) then
   raise exception 'concurrent transfer/refund inconsistency'; end if;
end $$;
SQL
