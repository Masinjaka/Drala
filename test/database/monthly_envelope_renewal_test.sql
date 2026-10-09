begin;
select set_config('request.jwt.claim.sub',
  '00000000-0000-0000-0000-000000000001', true);
insert into public.wallets(id,user_id,balance,is_default) values
 ('10000000-0000-0000-0000-000000000001',auth.uid(),1000,true),
 ('10000000-0000-0000-0000-000000000002',auth.uid(),50,false);
insert into public.categories(id,user_id,name,transaction_type) values
 ('20000000-0000-0000-0000-000000000001',auth.uid(),'Food','expense'),
 ('20000000-0000-0000-0000-000000000002',auth.uid(),'Travel','expense'),
 ('20000000-0000-0000-0000-000000000003',auth.uid(),'One off','expense');
select public.fund_monthly_envelope(
 'Food','20000000-0000-0000-0000-000000000001',100,
 (date_trunc('month',current_date) - interval '1 month')::date);
select public.fund_monthly_envelope(
 'Travel','20000000-0000-0000-0000-000000000002',50,
 (date_trunc('month',current_date) - interval '3 months')::date,
 '10000000-0000-0000-0000-000000000002');
select public.fund_envelope(
 'One off','20000000-0000-0000-0000-000000000003',100,
 (date_trunc('month',current_date) - interval '1 month')::date);
update public.envelopes set remaining_amount = 70
 where category_id = '20000000-0000-0000-0000-000000000001';
select public.renew_monthly_envelopes();
select public.renew_monthly_envelopes();
do $$
begin
  assert (select balance = 700 from public.wallets where is_default),
    'renewal debits exactly once';
  assert (select count(*) = 4 from public.envelopes),
    'one-off and unfunded schedules must not renew';
  assert (select remaining_amount = 70 from public.envelopes
    where name = 'Food' and period_month < date_trunc('month',current_date)),
    'historical spending is preserved';
  assert (select remaining_amount = 100 and overspent_amount = 0 and repeats_monthly
    from public.envelopes where name = 'Food'
      and period_month = date_trunc('month',current_date)),
    'current month is fully reset and scheduled';
end;
$$;
-- Insufficient funding is retried from the original wallet, never another.
update public.wallets set balance = 80
 where id = '10000000-0000-0000-0000-000000000002';
select public.renew_monthly_envelopes();
do $$
begin
  assert (select balance = 30 from public.wallets
    where id = '10000000-0000-0000-0000-000000000002');
  assert (select count(*) = 2 from public.envelopes where name = 'Travel'),
    'missed months are not backfilled or charged';
end;
$$;
-- Failed funding must leave the existing schedule and balances untouched.
do $$
begin
  begin
    perform public.fund_monthly_envelope(
      'Too large','20000000-0000-0000-0000-000000000001',10000,
      (current_date + interval '1 month')::date);
    raise exception 'expected funding failure';
  exception when raise_exception then
    if sqlerrm not like 'wallet_selection_required:%' then raise; end if;
  end;
  assert (select balance = 700 from public.wallets where is_default);
  assert (select count(*) = 1 from public.envelopes
    where name = 'Food' and repeats_monthly);
  assert not has_function_privilege('authenticated',
    'public.fund_envelope_before_monthly(text,uuid,bigint,date,uuid)','execute');
end;
$$;
-- Deleting the current instance stops renewal; old instances are inactive.
delete from public.envelopes where name = 'Food'
 and period_month = date_trunc('month',current_date);
select public.renew_monthly_envelopes();
select public.renew_monthly_envelopes((current_date - interval '2 years')::date);
select public.renew_monthly_envelopes((current_date + interval '1 month')::date);
do $$
begin
  assert (select count(*) = 1 from public.envelopes where name = 'Food');
  assert (select balance = 700 from public.wallets where is_default);
  assert not has_function_privilege('authenticated',
    'public.renew_monthly_envelopes_for_user(uuid,date)','execute');
  assert not has_function_privilege('anon',
    'public.renew_monthly_envelopes(date)','execute');
  assert not has_function_privilege('authenticated',
    'public.complete_finance_request(uuid,uuid,jsonb,jsonb,jsonb,jsonb,integer,integer,uuid,date,boolean)',
    'execute');
end;
$$;
-- A different user cannot renew the first user's envelopes.
select set_config('request.jwt.claim.sub',
  '00000000-0000-0000-0000-000000000002', true);
select public.renew_monthly_envelopes();
do $$
begin
  assert (select sum(balance) = 730 from public.wallets),
    'other users cannot charge these wallets';
end;
$$;
rollback;
