-- Minimal isolated schema for the real funding and renewal migrations.
create role anon;
create role authenticated;
create role service_role;
create schema auth;
create function auth.uid() returns uuid language sql stable as $$
  select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid
$$;
create table public.wallets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null, name text, balance bigint not null check(balance >= 0),
  currency_code text not null default 'MGA',
  is_default boolean default false, created_at timestamptz default now(),
  updated_at timestamptz default now()
);
create table public.categories (
  id uuid primary key, user_id uuid not null, name text,
  transaction_type text, emoji text, color text
);
create table public.envelopes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null, category_id uuid references public.categories,
  name text, amount bigint not null, currency_code text default 'MGA',
  overspent_amount bigint default 0, created_at timestamptz default now(),
  unique (user_id, category_id)
);
create table public."transaction" (
  id uuid primary key default gen_random_uuid(), user_id uuid,
  date timestamptz default now(), transaction_type text
);
-- Wrappers are exercised separately; business logic remains in real migrations.
create function public.route_expense_funds(uuid, uuid, boolean)
returns void language sql as $$ select $$;
create function public.complete_finance_request(
  uuid, uuid, jsonb, jsonb, jsonb, jsonb, integer, integer, uuid, date, boolean
) returns jsonb language sql as $$ select '{}'::jsonb $$;
create function public.create_manual_finance_entry(
 text,text,bigint,timestamptz,text,uuid,uuid,date,boolean
) returns jsonb language sql as $$ select '{}'::jsonb $$;
create function public.update_finance_entry(
 uuid,text,text,bigint,timestamptz,text,uuid,uuid,date,boolean
) returns jsonb language sql as $$ select '{}'::jsonb $$;
create function public.delete_finance_entry(uuid)
returns void language sql as $$ select $$;
create function public.delete_funded_envelope(p_envelope_id uuid)
returns void language sql as $$
 delete from public.envelopes where id = p_envelope_id and user_id = auth.uid()
$$;
