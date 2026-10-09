#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
container="drala-onboarding-$$"
trap 'docker rm -f "$container" >/dev/null 2>&1 || true' EXIT
docker run --detach --rm --name "$container" \
  -e POSTGRES_PASSWORD=local-test-only postgres:16-alpine >/dev/null
for attempt in {1..30}; do
  if docker exec "$container" pg_isready -U postgres >/dev/null 2>&1; then break; fi
  sleep 1
done
for sql in test/database/onboarding_fixture.sql \
  supabase/migrations/20261005192534_complete_onboarding.sql \
  supabase/migrations/20261009090000_localize_category_presets.sql \
  supabase/migrations/20261009090100_localize_onboarding_wallets.sql \
  test/database/onboarding_test.sql; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < "$sql"
done
