create role anon;
create role authenticated;
create schema auth;
create function auth.uid() returns uuid language sql stable as $$
  select nullif(current_setting('test.user_id', true), '')::uuid
$$;
create table public.wallets (
  id uuid primary key, user_id uuid not null, name text not null,
  balance bigint not null, currency_code text not null default 'MGA',
  updated_at timestamptz not null default now()
);
create table public.wallet_transfers (
  id uuid primary key, user_id uuid not null,
  from_wallet_id uuid not null references public.wallets(id),
  to_wallet_id uuid not null references public.wallets(id),
  amount bigint not null check (amount > 0), currency_code text not null,
  description text not null default '', occurred_at timestamptz not null,
  check (from_wallet_id <> to_wallet_id)
);
insert into public.wallets(id,user_id,name,balance) values
 ('10000000-0000-0000-0000-000000000001','00000000-0000-0000-0000-000000000001','Cash',1000),
 ('10000000-0000-0000-0000-000000000002','00000000-0000-0000-0000-000000000001','Bank',0),
 ('10000000-0000-0000-0000-000000000003','00000000-0000-0000-0000-000000000002','Other user',1000);
