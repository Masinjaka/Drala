create role anon;
create role authenticated;
create role service_role;
create schema auth;
create table public.wallets (
  id uuid primary key, user_id uuid not null,
  balance bigint not null check (balance >= 0),
  name text not null default 'Main wallet',
  currency_code text not null default 'MGA',
  icon_key text not null default 'wallet',
  is_default boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table public.envelopes (
  id uuid primary key, user_id uuid not null,
  category_id uuid not null, period_month date not null,
  name text not null, amount bigint not null default 0,
  remaining_amount bigint not null,
  overspent_amount bigint not null default 0,
  updated_at timestamptz not null default now()
);
create function public.complete_ai_request(
  p_request_id uuid, p_user_id uuid, p_provider_response jsonb,
  p_transactions jsonb, p_categories jsonb,
  p_input_tokens integer, p_output_tokens integer
) returns jsonb language plpgsql as $$
begin
  insert into public."transaction"(
    id,user_id,ai_request_id,transaction_type,amount,category_id,ledger_month
  )
  select gen_random_uuid(),p_user_id,p_request_id,'expense',
    (value->>'amount')::bigint,(value->>'category_id')::uuid,current_date
  from jsonb_array_elements(p_transactions) value;
  return '{"entries":[]}'::jsonb;
end;
$$;
create function public.credit_ai_income_to_default_wallet(uuid,uuid)
returns void language sql as $$ select $$;
create function public.commit_ai_wallet_transfers(uuid,uuid,jsonb)
returns jsonb language sql as $$ select '[]'::jsonb $$;
create table public."transaction" (
  id uuid primary key, user_id uuid not null,
  ai_request_id uuid,
  transaction_type text not null, amount bigint not null,
  category_id uuid not null, ledger_month date not null,
  envelope_id uuid, envelope_amount_used bigint not null default 0,
  source_wallet_id uuid
);
create table public.transaction_wallet_debits (
  transaction_id uuid not null, wallet_id uuid not null,
  user_id uuid not null, amount bigint not null,
  primary key (transaction_id, wallet_id)
);
create table public.finance_notifications (
  user_id uuid not null, notification_type text not null
    constraint finance_notifications_notification_type_check
      check (notification_type in ('envelope_overspent')),
  envelope_id uuid not null, transaction_id uuid not null,
  envelope_name text not null, amount bigint not null,
  period_month date not null,
  unique (transaction_id, notification_type)
);
create table public.notification_settings (
  user_id uuid primary key, warning_threshold numeric not null default 0.9
);
