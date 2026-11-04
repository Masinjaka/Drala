create function pg_temp.expect_error(expected text, command text)
returns void language plpgsql as $$ begin
  begin
    execute command;
    raise exception 'expected failure: %', expected;
  exception when others then
    if sqlerrm not like expected || '%' then raise; end if;
  end;
end $$;
create function public.test_block_envelope_delete() returns trigger
language plpgsql as $$ begin
  if old.name = 'fail' then raise exception 'test_delete_block'; end if;
  return old;
end $$;
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',false);
do $$
declare
  owner_id uuid := auth.uid();
  other_id uuid := '00000000-0000-0000-0000-000000000002';
  main_wallet uuid := gen_random_uuid();
  free_a uuid := gen_random_uuid();
  free_b uuid := gen_random_uuid();
  used_wallet uuid := gen_random_uuid();
  other_wallet uuid := gen_random_uuid();
  category_a uuid := gen_random_uuid();
  category_b uuid := gen_random_uuid();
  envelope_a uuid;
  envelope_b uuid;
  v_transaction_id uuid := gen_random_uuid();
begin
  insert into public.wallets(id,user_id,name,balance,is_default) values
    (main_wallet,owner_id,'Main',1000,true),
    (free_a,owner_id,'Free A',200,false),
    (free_b,owner_id,'Free B',300,false),
    (used_wallet,owner_id,'Used',500,false),
    (other_wallet,other_id,'Other',500,false);
  insert into public.categories(id,user_id,name,transaction_type) values
    (category_a,owner_id,'A','expense'), (category_b,owner_id,'B','expense');
  envelope_a := (public.fund_envelope('A',category_a,100,'2026-10-01',used_wallet)->>'id')::uuid;
  envelope_b := (public.fund_envelope('B',category_b,200,'2026-10-01',used_wallet)->>'id')::uuid;
  insert into public."transaction"(id,user_id,transaction_type,envelope_id,envelope_amount_used)
    values (v_transaction_id,owner_id,'expense',envelope_a,30);
  update public.envelopes set remaining_amount=70 where id=envelope_a;
  perform pg_temp.expect_error('wallet_in_use',format(
    'select public.delete_wallets(%L::uuid[])',array[free_a,used_wallet]));
  if not exists(select 1 from public.wallets where id=free_a) then
    raise exception 'partially deleted wallet batch'; end if;
  perform pg_temp.expect_error('default_wallet_cannot_be_deleted',format(
    'select public.delete_wallets(%L::uuid[])',array[free_a,main_wallet]));
  perform pg_temp.expect_error('wallet_not_found',format(
    'select public.delete_wallets(%L::uuid[])',array[free_a,other_wallet]));
  perform pg_temp.expect_error('envelope_not_found',format(
    'select public.delete_funded_envelopes(%L::uuid[])',array[envelope_a,gen_random_uuid()]));
  execute 'create trigger reject_envelope_delete before delete on public.envelopes
    for each row execute function public.test_block_envelope_delete()';
  update public.envelopes set name='fail' where id=envelope_b;
  perform pg_temp.expect_error('test_delete_block',format(
    'select public.delete_funded_envelopes(%L::uuid[])',array[envelope_a,envelope_b]));
  if (select count(*) from public.envelopes where id in (envelope_a,envelope_b)) <> 2 or
     (select balance from public.wallets where id=used_wallet) is distinct from 200 then
    raise exception 'failed envelope batch did not roll back'; end if;
  execute 'drop trigger reject_envelope_delete on public.envelopes';
  perform public.delete_funded_envelopes(array[envelope_a,envelope_b,envelope_a]);
  if exists(select 1 from public.envelopes where id in (envelope_a,envelope_b)) or
     (select balance from public.wallets where id=used_wallet) is distinct from 470 then
    raise exception 'incorrect envelope batch refund'; end if;
  if not exists(select 1 from public."transaction" where id=v_transaction_id
        and envelope_id is null and envelope_amount_used=0) or
     (select amount from public.transaction_wallet_debits where transaction_id=v_transaction_id) is distinct from 30 then
    raise exception 'expense reversal history lost'; end if;
  perform public.delete_wallets(array[free_a,free_b,free_a]);
  if exists(select 1 from public.wallets where id in (free_a,free_b)) then
    raise exception 'wallet batch was not deleted'; end if;
  if not exists(select 1 from public.wallets where id=other_wallet) then
    raise exception 'another user wallet deleted'; end if;
  perform set_config('request.jwt.claim.sub','',false);
  perform pg_temp.expect_error('unauthorized',format(
    'select public.delete_wallets(%L::uuid[])',array[main_wallet]));
end $$;
