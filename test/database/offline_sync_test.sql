insert into auth.users values
 ('00000000-0000-0000-0000-000000000001','{}'),('00000000-0000-0000-0000-000000000002','{}');
insert into public."user"(user_id,username) select id,'Test' from auth.users;
insert into public.wallets(id,user_id,name,balance,is_default) values
 ('10000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000001','Cash',1000,true),
 ('10000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001','Bank',0,false),
 ('10000000-0000-0000-0000-000000000003','00000000-0000-0000-0000-000000000002','Foreign',5000,true);
insert into public.categories(id,user_id,name,transaction_type,emoji) values
 ('20000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000001','Food','expense','🍎'),
 ('20000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001','Salary','income','💰');
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',false);
do $$ declare v_revision bigint; v_after bigint; v_ops jsonb; v_rows jsonb; begin
 v_revision:=public.offline_sync_revision();
 v_ops:='[
  {"id":"60000000-0000-0000-0000-000000000001","table":"transaction","record_id":"30000000-0000-0000-0000-000000000001","operation":"upsert","payload":{"title":"Income","amount":200,"transaction_type":"income","date":"2026-10-01T12:00:00Z","category_id":"20000000-0000-0000-0000-000000000002","source_wallet_id":"10000000-0000-0000-0000-000000000002"}},
  {"id":"60000000-0000-0000-0000-000000000002","table":"envelopes","record_id":"40000000-0000-0000-0000-000000000001","operation":"upsert","payload":{"name":"Food","category_id":"20000000-0000-0000-0000-000000000001","amount":100,"period_month":"2026-10-01","funding_wallet_id":"10000000-0000-0000-0000-000000000001"}},
  {"id":"60000000-0000-0000-0000-000000000003","table":"transaction","record_id":"30000000-0000-0000-0000-000000000002","operation":"upsert","payload":{"title":"Lunch","amount":70,"transaction_type":"expense","date":"2026-10-01T13:00:00Z","category_id":"20000000-0000-0000-0000-000000000001","source_wallet_id":"10000000-0000-0000-0000-000000000001"}},
  {"id":"60000000-0000-0000-0000-000000000004","table":"wallet_transfers","record_id":"50000000-0000-0000-0000-000000000001","operation":"upsert","payload":{"from_wallet_id":"10000000-0000-0000-0000-000000000001","to_wallet_id":"10000000-0000-0000-0000-000000000002","amount":40,"occurred_at":"2026-10-01T14:00:00Z","description":"Transfer"}}
 ]';
 v_after:=public.apply_offline_batch('70000000-0000-0000-0000-000000000001',v_revision,v_ops);
 if (select balance from public.wallets where name='Cash')<>860 or
    (select balance from public.wallets where name='Bank')<>240 or
    (select remaining_amount from public.envelopes)<>30 then raise exception 'ledger replay is incorrect'; end if;
 v_rows:=public.offline_pull_page('transaction');
 if jsonb_array_length(v_rows)<>2 or not exists(select 1 from jsonb_array_elements(v_rows) r
   where r->>'id'='30000000-0000-0000-0000-000000000001' and r->>'source_wallet_id'='10000000-0000-0000-0000-000000000002')
 then raise exception 'stable client IDs or income wallet lost during pull'; end if;
 update public.wallets set balance=balance+10 where name='Cash';
 if public.apply_offline_batch('70000000-0000-0000-0000-000000000001',v_revision,v_ops)<>v_after then raise exception 'receipt was not reused'; end if;
 if (select count(*) from public."transaction")<>2 or (select balance from public.wallets where name='Cash')<>870
 then raise exception 'retry duplicated a financial effect'; end if;
 begin
  perform public.apply_offline_batch('70000000-0000-0000-0000-000000000002',v_after,v_ops);
  raise exception 'stale revision was accepted';
 exception when others then if sqlerrm<>'offline_sync_conflict' then raise; end if; end;
 begin
  perform public.apply_offline_batch('70000000-0000-0000-0000-000000000001',v_after,'[{"operation":"delete"}]');
  raise exception 'reused ID accepted a different body';
 exception when others then if sqlerrm<>'offline_batch_id_conflict' then raise; end if; end;
 if exists(select 1 from jsonb_array_elements(public.offline_pull_changes(v_revision,public.offline_sync_revision())) r
   where r->'payload'->>'user_id'<>'00000000-0000-0000-0000-000000000001') then raise exception 'change feed leaked another account'; end if;
end $$;
do $$ declare v_before bigint; v_operations jsonb; begin
 v_before:=public.offline_sync_revision();
 v_operations:='[
  {"id":"60000000-0000-0000-0000-000000000005","table":"categories","record_id":"20000000-0000-0000-0000-000000000003","operation":"upsert","payload":{"name":"Rollback","transaction_type":"expense"}},
  {"id":"60000000-0000-0000-0000-000000000006","table":"wallets","record_id":"10000000-0000-0000-0000-000000000003","operation":"delete","payload":{}}
 ]';
 begin
  perform public.apply_offline_batch('70000000-0000-0000-0000-000000000003',v_before,v_operations);
  raise exception 'cross-account mutation accepted';
 exception when others then if sqlerrm<>'offline_ownership_violation' then raise; end if; end;
 if exists(select 1 from public.categories where name='Rollback') or public.offline_sync_revision()<>v_before
 then raise exception 'failed batch was not atomic'; end if;
 insert into public.categories(id,user_id,name,transaction_type) values
  ('20000000-0000-0000-0000-000000000004',auth.uid(),'Tombstone','expense');
 delete from public.categories where name='Tombstone';
 if not exists(select 1 from jsonb_array_elements(public.offline_pull_changes(v_before,public.offline_sync_revision())) r
  where r->>'table'='categories' and (r->'payload'->>'_deleted')::boolean)
 then raise exception 'deletion was not synced'; end if;
 if has_table_privilege('authenticated','public.offline_batch_receipts','SELECT') or
   has_function_privilege('anon','public.apply_offline_batch(uuid,bigint,jsonb)','EXECUTE') or
   has_function_privilege('authenticated','public.offline_apply_record(text,uuid,text,jsonb)','EXECUTE')
 then raise exception 'private protocol helpers were exposed'; end if;
end $$;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000002',false);
do $$ begin
 if jsonb_array_length(public.offline_pull_page('wallets'))<>1 or
    jsonb_array_length(public.offline_pull_page('transaction'))<>0 then raise exception 'account isolation failed'; end if;
 delete from auth.users where id=auth.uid();
 if exists(select 1 from public.offline_account_revisions where user_id=auth.uid()) then raise exception 'account deletion left sync metadata'; end if;
end $$;

select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',false);
do $$ begin
 perform public.apply_offline_batch(gen_random_uuid(),public.offline_sync_revision(),
 '[{"id":"60000000-0000-0000-0000-000000000088","table":"categories","record_id":"20000000-0000-0000-0000-000000000001","operation":"upsert","payload":{"name":"Food updated","transaction_type":"expense","icon_key":"restaurant"}}]');
 if not exists(select 1 from public.categories where name='Food updated' and icon_key='restaurant') then
   raise exception 'category upsert failed against the deployed schema'; end if;
end $$;
