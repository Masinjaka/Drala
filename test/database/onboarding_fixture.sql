create role anon;
create role authenticated;
create schema auth;
create table auth.users(id uuid primary key, raw_user_meta_data jsonb);
create function auth.uid() returns uuid language sql as $$
  select nullif(current_setting('test.user_id', true), '')::uuid
$$;
create table public."user"(user_id uuid primary key, currency_code text);
create table public.categories(id uuid primary key default gen_random_uuid(),
  user_id uuid, name text, emoji text, color text, icon_key text, transaction_type text);
create unique index categories_user_name_type_uidx on public.categories
  (user_id, lower(name), coalesce(transaction_type, 'expense'));
create table public.category_presets(slug text primary key, name text, emoji text,
  color text, icon_key text, transaction_type text);
create table public.wallets(id uuid primary key default gen_random_uuid(),
  user_id uuid, name text, balance bigint default 0, icon_key text default 'wallet',
  is_default boolean default false, currency_code text default 'MGA');
create unique index wallets_user_name_unique on public.wallets(user_id, lower(name));
create unique index wallets_one_default_per_user on public.wallets(user_id) where is_default;
insert into public.category_presets values
  ('food', 'Foods & Drinks', 'food', 'FFFF9800','food','expense'),
  ('salary', 'Salary', 'salary','FF4CAF50','salary','income');
insert into auth.users values
  ('00000000-0000-0000-0000-000000000001','{"onboarding_required":true}'),
  ('00000000-0000-0000-0000-000000000002','{"onboarding_required":true}');
insert into public."user" select id,'MGA' from auth.users;
insert into public.wallets(user_id,name,is_default,balance)
  values ('00000000-0000-0000-0000-000000000001','Main wallet',true,12345);
