create table public.wallet_transfers (
  id uuid primary key, user_id uuid not null,
  from_wallet_id uuid not null references public.wallets(id),
  to_wallet_id uuid not null references public.wallets(id),
  amount bigint not null, currency_code text not null,
  description text not null, occurred_at timestamptz not null
);
select set_config('request.jwt.claim.sub','00000000-0000-0000-0000-000000000003',false);
insert into public.wallets(id,user_id,name,balance) values
 ('30000000-0000-0000-0000-000000000001',auth.uid(),'Concurrent A',1000),
 ('30000000-0000-0000-0000-000000000002',auth.uid(),'Concurrent B',1000);
insert into public.categories(id,user_id,name,transaction_type) values
 ('40000000-0000-0000-0000-000000000001',auth.uid(),'Concurrent A','expense'),
 ('40000000-0000-0000-0000-000000000002',auth.uid(),'Concurrent B','expense');
-- Envelope ID order intentionally opposes wallet order.
insert into public.envelopes
 (id,user_id,category_id,name,amount,remaining_amount,funding_wallet_id,period_month)
values
 ('50000000-0000-0000-0000-000000000001',auth.uid(),
  '40000000-0000-0000-0000-000000000002','B',100,100,
  '30000000-0000-0000-0000-000000000002','2026-10-01'),
 ('50000000-0000-0000-0000-000000000002',auth.uid(),
  '40000000-0000-0000-0000-000000000001','A',100,100,
  '30000000-0000-0000-0000-000000000001','2026-10-01');
update public.wallets set balance=900 where name in ('Concurrent A','Concurrent B');
