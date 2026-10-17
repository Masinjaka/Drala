-- Exchange rates contain public market data and are needed before sign in.
do $$
begin
  if to_regclass('public.exchange_rates') is null then
    return;
  end if;

  grant select on public.exchange_rates to anon;
  alter table public.exchange_rates enable row level security;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'exchange_rates'
      and policyname = 'exchange_rates_public_read'
  ) then
    create policy exchange_rates_public_read on public.exchange_rates
      for select to anon using (true);
  end if;
end $$;
