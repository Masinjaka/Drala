select set_config('test.user_id','00000000-0000-0000-0000-000000000001',false);
create function pg_temp.expect_error(
  expected text, transfer_id uuid, source_id uuid, destination_id uuid, amount bigint
) returns void language plpgsql as $$
begin
  begin
    perform public.create_manual_wallet_transfer(
      transfer_id, source_id, destination_id, amount, now(), '');
    raise exception 'expected failure: %', expected;
  exception when others then
    if sqlerrm not like expected || '%' then raise; end if;
  end;
end $$;
do $$
declare
  a uuid := '10000000-0000-0000-0000-000000000001';
  b uuid := '10000000-0000-0000-0000-000000000002';
  other_wallet uuid := '10000000-0000-0000-0000-000000000003';
  submission uuid := '20000000-0000-0000-0000-000000000001';
  result jsonb;
begin
  if has_function_privilege('anon',
    'public.create_manual_wallet_transfer(uuid,uuid,uuid,bigint,timestamptz,text)',
    'execute') then raise exception 'anonymous transfer permission'; end if;
  if not has_function_privilege('authenticated',
    'public.create_manual_wallet_transfer(uuid,uuid,uuid,bigint,timestamptz,text)',
    'execute') then raise exception 'missing authenticated permission'; end if;
  perform pg_temp.expect_error('invalid_transfer_amount',submission,a,b,0);
  perform pg_temp.expect_error('invalid_transfer_amount',submission,a,b,null);
  perform pg_temp.expect_error('same_wallet_transfer',submission,a,a,100);
  perform pg_temp.expect_error('wallet_not_found',submission,a,other_wallet,100);
  perform pg_temp.expect_error('wallet_not_found',submission,other_wallet,b,100);
  perform pg_temp.expect_error('insufficient_funds:',submission,a,b,1001);
  update public.wallets set currency_code='EUR' where id=b;
  perform pg_temp.expect_error('wallet_currency_mismatch',submission,a,b,100);
  update public.wallets set currency_code='MGA' where id=b;
  if (select count(*) from public.wallet_transfers) <> 0 or
     (select balance from public.wallets where id=a) is distinct from 1000 then
    raise exception 'failed operation mutated ledger'; end if;
  result := public.create_manual_wallet_transfer(submission,a,b,200,now(),'Savings');
  if result->>'entry_type' <> 'transfer' or result->>'amount' <> '200' then
    raise exception 'incorrect entry result'; end if;
  if (select balance from public.wallets where id=a) is distinct from 800 or
     (select balance from public.wallets where id=b) is distinct from 200 then
    raise exception 'incorrect balance update'; end if;
  perform public.create_manual_wallet_transfer(submission,a,b,200,now(),'Savings');
  if (select count(*) from public.wallet_transfers) <> 1 or
     (select balance from public.wallets where id=a) is distinct from 800 then
    raise exception 'retry debited twice'; end if;
  perform pg_temp.expect_error('transfer_id_conflict',submission,a,b,100);
  perform set_config('test.user_id','00000000-0000-0000-0000-000000000002',false);
  perform pg_temp.expect_error('transfer_id_conflict',submission,a,b,200);
  perform set_config('test.user_id','',false);
  perform pg_temp.expect_error('unauthorized',gen_random_uuid(),a,b,100);
end $$;
