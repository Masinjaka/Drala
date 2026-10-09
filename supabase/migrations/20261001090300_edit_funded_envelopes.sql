begin;

create function public.update_funded_envelope(
  p_envelope_id uuid, p_name text, p_category_id uuid,
  p_amount bigint, p_repeats_monthly boolean
) returns void language plpgsql security definer set search_path = '' as $$
declare
  v_user uuid := auth.uid();
  v_envelope public.envelopes%rowtype;
  v_wallet public.wallets%rowtype;
  v_delta bigint;
begin
  perform public.lock_envelope_funding();
  if p_name is null or trim(p_name) = '' or p_amount is null or p_amount <= 0
    or p_repeats_monthly is null then
    raise exception 'invalid_envelope';
  end if;
  select * into v_envelope from public.envelopes
  where id = p_envelope_id and user_id = v_user for update;
  if not found then raise exception 'envelope_not_found'; end if;
  if not exists (select 1 from public.categories
    where id = p_category_id and user_id = v_user and transaction_type = 'expense')
  then raise exception 'category_not_found'; end if;
  v_delta := p_amount - v_envelope.amount;
  if v_envelope.remaining_amount + v_delta < 0 then
    raise exception 'envelope_amount_below_spent';
  end if;
  select * into v_wallet from public.wallets
  where id = v_envelope.funding_wallet_id and user_id = v_user for update;
  if not found then raise exception 'wallet_not_found'; end if;
  if v_wallet.balance < v_delta then
    raise exception 'insufficient_funds:%:%', v_delta, v_wallet.balance;
  end if;
  if p_repeats_monthly then
    if exists (select 1 from public.envelopes
      where user_id = v_user and category_id = p_category_id
        and period_month > v_envelope.period_month) then
      raise exception 'monthly_schedule_not_latest';
    end if;
    update public.envelopes set repeats_monthly = false
    where user_id = v_user and category_id = p_category_id and repeats_monthly
      and id <> p_envelope_id;
  end if;
  update public.envelopes set name = trim(p_name), category_id = p_category_id,
    amount = p_amount, remaining_amount = remaining_amount + v_delta,
    repeats_monthly = p_repeats_monthly, updated_at = now()
  where id = p_envelope_id;
  update public.wallets set balance = balance - v_delta, updated_at = now()
  where id = v_wallet.id;
end;
$$;
revoke all on function public.update_funded_envelope(uuid,text,uuid,bigint,boolean)
  from public, anon;
grant execute on function public.update_funded_envelope(uuid,text,uuid,bigint,boolean)
  to authenticated;

-- Preserve expense reversibility after deleting a spent envelope: its consumed
-- allocation becomes a recorded wallet debit, without charging the wallet again.
create or replace function public.delete_funded_envelope(p_envelope_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_user uuid := auth.uid();
  v_envelope public.envelopes%rowtype;
begin
  perform public.lock_envelope_funding();
  select * into v_envelope from public.envelopes
  where id = p_envelope_id and user_id = v_user for update;
  if not found then raise exception 'envelope_not_found'; end if;
  insert into public.transaction_wallet_debits(transaction_id,wallet_id,user_id,amount)
    select id,v_envelope.funding_wallet_id,v_user,envelope_amount_used
    from public."transaction"
    where envelope_id = p_envelope_id and user_id = v_user and envelope_amount_used > 0
  on conflict (transaction_id,wallet_id) do update
    set amount = public.transaction_wallet_debits.amount + excluded.amount;
  update public."transaction" set envelope_id = null, envelope_amount_used = 0
  where envelope_id = p_envelope_id and user_id = v_user;
  update public.wallets
  set balance = balance + v_envelope.remaining_amount, updated_at = now()
  where id = v_envelope.funding_wallet_id and user_id = v_user;
  delete from public.envelopes where id = p_envelope_id;
end;
$$;

commit;
