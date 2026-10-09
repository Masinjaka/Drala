select set_config('request.jwt.claim.sub',
  '00000000-0000-0000-0000-000000000003', false);
insert into public.wallets(id,user_id,balance,is_default) values
 ('10000000-0000-0000-0000-000000000003',auth.uid(),1000,true);
insert into public.categories(id,user_id,name,transaction_type) values
 ('20000000-0000-0000-0000-000000000004',auth.uid(),'Concurrent','expense');
select public.fund_monthly_envelope(
 'Concurrent','20000000-0000-0000-0000-000000000004',100,
 (date_trunc('month',current_date) - interval '1 month')::date);
