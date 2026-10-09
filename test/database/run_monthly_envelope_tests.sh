#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
container="drala-envelope-tests-$$"
trap 'docker rm -f "$container" >/dev/null 2>&1 || true' EXIT
docker run --detach --rm --name "$container" \
  -e POSTGRES_PASSWORD=local-test-only postgres:16-alpine >/dev/null
for attempt in {1..30}; do
  if docker exec "$container" pg_isready -U postgres >/dev/null 2>&1; then
    break
  fi
  sleep 1
done
for sql in \
  test/database/monthly_envelope_fixture.sql \
  supabase/migrations/20260718090300_add_funded_envelope_ledger.sql \
  supabase/migrations/20261001090000_add_monthly_envelope_renewal.sql \
  supabase/migrations/20261001090100_renew_envelopes_before_expenses.sql \
  supabase/migrations/20261001090200_serialize_monthly_envelope_funding.sql \
  test/database/monthly_envelope_renewal_test.sql \
  test/database/envelope_edit_fixture.sql \
  supabase/migrations/20261001090300_edit_funded_envelopes.sql \
  test/database/envelope_edit_test.sql; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < "$sql"
done
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1   < test/database/monthly_envelope_concurrency_setup.sql
worker_pids=()
for worker_index in 1 2; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1     < test/database/monthly_envelope_concurrency_worker.sql &
  worker_pids+=("$!")
done
for worker_pid in "${worker_pids[@]}"; do
  wait "$worker_pid"
done
docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1   < test/database/monthly_envelope_concurrency_assert.sql
