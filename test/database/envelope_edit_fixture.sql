alter table public.envelopes add column updated_at timestamptz default now();
alter table public."transaction"
  add column envelope_id uuid references public.envelopes(id),
  add column envelope_amount_used bigint not null default 0;
create table public.transaction_wallet_debits (
  transaction_id uuid references public."transaction"(id),
  wallet_id uuid references public.wallets(id), user_id uuid, amount bigint,
  primary key(transaction_id,wallet_id)
);
