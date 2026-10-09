begin;
select set_config('request.jwt.claim.sub',
  '00000000-0000-0000-0000-000000000001', true);
insert into public.wallets(id,user_id,balance,is_default) values
 ('10000000-0000-0000-0000-000000000001',auth.uid(),1000,true);
insert into public.categories(id,user_id,name,transaction_type) values
 ('20000000-0000-0000-0000-000000000001',auth.uid(),'Food','expense'),
 ('20000000-0000-0000-0000-000000000002',auth.uid(),'Travel','expense');
select public.fund_envelope('Food','20000000-0000-0000-0000-000000000001',100,current_date);
do $$
declare e uuid := (select id from public.envelopes); c uuid;
begin
  select category_id into c from public.envelopes where id=e;
  perform public.update_funded_envelope(e,'Groceries',c,200,true);
  assert (select balance=800 from public.wallets);
  assert (select remaining_amount=200 and name='Groceries' and repeats_monthly
    from public.envelopes where id=e);
  perform public.update_funded_envelope(e,'Food',c,150,false);
  assert (select balance=850 from public.wallets);
  begin
    perform public.update_funded_envelope(e,'Food',c,2000,false);
    raise exception 'expected failure';
  exception when raise_exception then
    if sqlerrm not like 'insufficient_funds:%' then raise; end if;
  end;
  assert (select balance=850 from public.wallets);
  -- Simulate an expense funded 50 by this envelope and 20 by its wallet.
  update public.envelopes set remaining_amount=100 where id=e;
  update public.wallets set balance=balance-20;
  insert into public."transaction"(id,user_id,envelope_id,envelope_amount_used)
    values('30000000-0000-0000-0000-000000000001',auth.uid(),e,50);
  insert into public.transaction_wallet_debits values
    ('30000000-0000-0000-0000-000000000001',
     '10000000-0000-0000-0000-000000000001',auth.uid(),20);
  begin
    perform public.update_funded_envelope(e,'Food',c,40,false);
    raise exception 'expected failure';
  exception when raise_exception then
    if sqlerrm <> 'envelope_amount_below_spent' then raise; end if;
  end;
  perform set_config('request.jwt.claim.sub',gen_random_uuid()::text,true);
  begin
    perform public.update_funded_envelope(e,'Other user',c,150,false);
    raise exception 'expected failure';
  exception when raise_exception then
    if sqlerrm <> 'envelope_not_found' then raise; end if;
  end;
  perform set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000001',true);
  perform public.delete_funded_envelope(e);
  assert (select count(*)=0 from public.envelopes);
  assert (select balance=930 from public.wallets), 'only unspent funds refunded';
  assert (select envelope_id is null and envelope_amount_used=0 from public."transaction");
  assert (select amount=70 from public.transaction_wallet_debits),
    'later expense reversal can refund the full original amount';
  assert not has_function_privilege('anon',
    'public.update_funded_envelope(uuid,text,uuid,bigint,boolean)','execute');
end;
$$;
rollback;
