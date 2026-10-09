begin;
set local statement_timeout = '5s';
select set_config('request.jwt.claim.sub',
  '00000000-0000-0000-0000-000000000003', true);
select public.renew_monthly_envelopes();
select pg_sleep(0.2);
commit;
