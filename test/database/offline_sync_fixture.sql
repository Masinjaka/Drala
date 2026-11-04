create role anon;
create role authenticated;
create role service_role;
create schema auth;
create table auth.users(id uuid primary key, raw_user_meta_data jsonb default '{}');
create function auth.uid() returns uuid language sql stable as $$
 select nullif(current_setting('request.jwt.claim.sub',true),'')::uuid
$$;
create table public."user"(user_id uuid primary key references auth.users(id) on delete cascade,
 username text, currency_code text default 'MGA', profile_photo text);
create table public.wallets(id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade, name text not null,
 balance bigint not null default 0, currency_code text default 'MGA', icon_key text default 'wallet',
 is_default boolean default false, created_at timestamptz default now(),updated_at timestamptz default now());
create unique index wallets_one_default_per_user on public.wallets(user_id) where is_default;
create table public.categories(id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,name text,transaction_type text,
 emoji text,color text,icon_key text default 'other',created_at timestamptz default now());
create unique index categories_user_name_type_uidx on public.categories(user_id,lower(name),coalesce(transaction_type,'expense'));
create table public.envelopes(id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 category_id uuid references public.categories(id),name text,amount bigint not null,
 currency_code text default 'MGA',overspent_amount bigint default 0,
 created_at timestamptz default now(),updated_at timestamptz default now(),unique(user_id,category_id));
create table public."transaction"(id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,title text,description text default '',
 amount bigint not null default 0,date timestamptz default now(),transaction_type text,currency_code text default 'MGA',
 category_id uuid references public.categories(id),source_wallet_id uuid references public.wallets(id),
 envelope_id uuid references public.envelopes(id),envelope_amount_used bigint default 0,
 created_at timestamptz default now(),updated_at timestamptz default now());
create table public.wallet_income_credits(transaction_id uuid primary key references public."transaction"(id) on delete cascade,
 wallet_id uuid references public.wallets(id),user_id uuid,amount bigint,currency_code text);
create table public.transaction_wallet_debits(transaction_id uuid references public."transaction"(id) on delete cascade,
 wallet_id uuid references public.wallets(id),user_id uuid,amount bigint,primary key(transaction_id,wallet_id));
create table public.wallet_transfers(id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 from_wallet_id uuid constraint wallet_transfer_from_wallet_fkey references public.wallets(id),
 to_wallet_id uuid constraint wallet_transfer_to_wallet_fkey references public.wallets(id),
 amount bigint,currency_code text,description text,occurred_at timestamptz,created_at timestamptz default now());
create table public.finance_notifications(id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,notification_type text,
 envelope_id uuid references public.envelopes(id) on delete cascade,
 transaction_id uuid references public."transaction"(id) on delete cascade,
 envelope_name text,amount bigint,period_month date,is_read boolean default false,created_at timestamptz default now());
create table public.notification_settings(user_id uuid primary key references auth.users(id) on delete cascade,
 notifications_enabled boolean default true,reminders_enabled boolean default true,warnings_enabled boolean default true,
 reminder_hour int default 10,reminder_minute int default 0,timezone_offset_minutes int default 0,
 warning_threshold numeric default .9,updated_at timestamptz default now());
-- Legacy overload retained by the real manual-entry migration.
create function public.create_manual_finance_entry(text,text,bigint,timestamptz,text,uuid,uuid,date)
 returns jsonb language sql as $$ select '{}'::jsonb $$;
-- AI completion is not invoked by the offline manual-mutation protocol.
create function public.complete_finance_request(uuid,uuid,jsonb,jsonb,jsonb,jsonb,integer,integer,uuid,date,boolean)
 returns jsonb language sql as $$ select '{}'::jsonb $$;

-- Replaced by the real funded-envelope deletion migration before tests run.
create function public.delete_funded_envelope(uuid) returns void language sql as $$ select $$;
