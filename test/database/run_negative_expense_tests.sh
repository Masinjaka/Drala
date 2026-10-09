#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../.."
container="drala-negative-expense-$$"
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
  test/database/negative_expense_fixture.sql \
  supabase/migrations/20261005090000_allow_negative_expense_wallet.sql \
  test/database/negative_expense_test.sql \
  supabase/migrations/20261005090100_allow_ai_negative_expenses.sql \
  test/database/negative_ai_expense_test.sql \
  supabase/migrations/20261005090200_notification_language.sql \
  test/database/notification_language_test.sql \
  supabase/migrations/20261005090300_emit_envelope_threshold_alerts.sql \
  test/database/envelope_threshold_alert_test.sql; do
  docker exec -i "$container" psql -U postgres -v ON_ERROR_STOP=1 < "$sql"
done
