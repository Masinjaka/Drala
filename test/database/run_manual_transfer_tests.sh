#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
container="drala-manual-transfer-$$"
trap 'docker rm -f "$container" >/dev/null 2>&1 || true' EXIT
docker run --detach --rm --name "$container" \
  -e POSTGRES_PASSWORD=local-test-only postgres:16-alpine >/dev/null
for attempt in {1..30}; do
  if docker exec "$container" pg_isready -U postgres >/dev/null 2>&1; then break; fi
  sleep 1
done
for sql in test/database/manual_transfer_fixture.sql \
  supabase/migrations/20261027132335_manual_wallet_transfers.sql \
  test/database/manual_transfer_test.sql; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < "$sql"
done
# Identical retries racing on separate connections must debit only once.
for worker in 1 2; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 <<'SQL' &
select set_config('test.user_id','00000000-0000-0000-0000-000000000001',false);
select public.create_manual_wallet_transfer(
 '20000000-0000-0000-0000-000000000002',
 '10000000-0000-0000-0000-000000000001',
 '10000000-0000-0000-0000-000000000002',100,now(),'Concurrent retry');
SQL
  if [[ "$worker" == 1 ]]; then first_pid=$!; else second_pid=$!; fi
done
wait "$first_pid"
wait "$second_pid"
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 <<'SQL'
do $$ begin
 if (select count(*) from public.wallet_transfers) <> 2 or
    (select balance from public.wallets where name='Cash') is distinct from 700 or
    (select balance from public.wallets where name='Bank') is distinct from 300 then
   raise exception 'concurrent retry duplicated the transfer'; end if;
end $$;
SQL
