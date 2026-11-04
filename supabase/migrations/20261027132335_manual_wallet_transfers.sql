begin;

create or replace function public.create_manual_wallet_transfer(
  p_transfer_id uuid,
  p_from_wallet_id uuid,
  p_to_wallet_id uuid,
  p_amount bigint,
  p_occurred_at timestamptz,
  p_description text default ''
) returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_from public.wallets%rowtype;
  v_to public.wallets%rowtype;
  v_transfer public.wallet_transfers%rowtype;
  v_description text := left(coalesce(p_description, ''), 500);
begin
  if v_user is null then raise exception 'unauthorized'; end if;
  if p_transfer_id is null or p_amount is null or p_amount <= 0 then
    raise exception 'invalid_transfer_amount';
  end if;
  if p_from_wallet_id is null or p_to_wallet_id is null then
    raise exception 'wallet_not_found';
  end if;
  if p_from_wallet_id = p_to_wallet_id then
    raise exception 'same_wallet_transfer';
  end if;

  -- Serialize identical submission IDs before checking for a completed retry.
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_transfer_id::text, 0));
  select * into v_transfer from public.wallet_transfers
    where id = p_transfer_id;
  if found then
    if v_transfer.user_id <> v_user or
       v_transfer.from_wallet_id <> p_from_wallet_id or
       v_transfer.to_wallet_id <> p_to_wallet_id or
       v_transfer.amount <> p_amount or
       v_transfer.description <> v_description then
      raise exception 'transfer_id_conflict';
    end if;
  else
    -- Consistent ordering also prevents opposite transfers from deadlocking.
    perform 1 from public.wallets
      where user_id = v_user and id in (p_from_wallet_id, p_to_wallet_id)
      order by id for update;
    select * into v_from from public.wallets
      where id = p_from_wallet_id and user_id = v_user;
    select * into v_to from public.wallets
      where id = p_to_wallet_id and user_id = v_user;
    if v_from.id is null or v_to.id is null then
      raise exception 'wallet_not_found';
    end if;
    -- The app's editable amounts and ledger are denominated in MGA.
    if v_from.currency_code <> 'MGA' or v_to.currency_code <> 'MGA' then
      raise exception 'wallet_currency_mismatch';
    end if;
    if v_from.balance < p_amount then
      raise exception 'insufficient_funds:%:%', p_amount, v_from.balance;
    end if;
    update public.wallets set balance = balance - p_amount, updated_at = now()
      where id = v_from.id;
    update public.wallets set balance = balance + p_amount, updated_at = now()
      where id = v_to.id;
    insert into public.wallet_transfers (
      id, user_id, from_wallet_id, to_wallet_id, amount, currency_code,
      description, occurred_at
    ) values (
      p_transfer_id, v_user, v_from.id, v_to.id, p_amount, 'MGA',
      v_description, least(coalesce(p_occurred_at, now()), now())
    ) returning * into v_transfer;
  end if;
  return jsonb_build_object(
    'id', v_transfer.id, 'entry_type', 'transfer',
    'title', coalesce(nullif(v_transfer.description, ''), 'Transfer'),
    'description', v_transfer.description, 'amount', v_transfer.amount,
    'date', v_transfer.occurred_at, 'transaction_type', 'transfer',
    'currency_code', v_transfer.currency_code,
    'source_wallet_id', v_transfer.from_wallet_id,
    'category', jsonb_build_object('name', 'Transfer', 'icon_key', 'transfer')
  );
end;
$$;

revoke all on function public.create_manual_wallet_transfer(
  uuid, uuid, uuid, bigint, timestamptz, text) from public, anon;
grant execute on function public.create_manual_wallet_transfer(
  uuid, uuid, uuid, bigint, timestamptz, text) to authenticated;

commit;
