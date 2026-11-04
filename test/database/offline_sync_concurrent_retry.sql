-- Both independent connections use the same persisted batch and base revision.
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',false);
select public.apply_offline_batch('70000000-0000-0000-0000-000000000099',
 (select revision from test_sync_revision),
 '[{"id":"60000000-0000-0000-0000-000000000099","table":"transaction","record_id":"30000000-0000-0000-0000-000000000099","operation":"upsert","payload":{"title":"Concurrent expense","amount":17,"transaction_type":"expense","date":"2026-10-01T13:00:00Z","category_id":"20000000-0000-0000-0000-000000000001","source_wallet_id":"10000000-0000-0000-0000-000000000001"}}]');
