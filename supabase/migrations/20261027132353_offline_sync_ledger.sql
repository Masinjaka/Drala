begin;
create function public.offline_move_income_wallet(p_transaction uuid,p_target uuid)
returns void language plpgsql security definer set search_path='' as $$
declare v_user uuid:=auth.uid(); v_credit public.wallet_income_credits%rowtype;
  v_target uuid; v_balance bigint;
begin
  select * into v_credit from public.wallet_income_credits
    where transaction_id=p_transaction and user_id=v_user for update;
  if not found then raise exception 'income_credit_not_found'; end if;
  v_target:=coalesce(p_target,v_credit.wallet_id);
  perform 1 from public.wallets where user_id=v_user and id in (v_target,v_credit.wallet_id) order by id for update;
  if not exists(select 1 from public.wallets where id=v_target and user_id=v_user
    and currency_code=v_credit.currency_code) then raise exception 'wallet_currency_mismatch'; end if;
  if v_target<>v_credit.wallet_id then
    select balance into v_balance from public.wallets where id=v_credit.wallet_id and user_id=v_user;
    if v_balance<v_credit.amount then raise exception 'insufficient_funds:%:%',v_credit.amount,v_balance; end if;
    update public.wallets set balance=balance-v_credit.amount,updated_at=now() where id=v_credit.wallet_id and user_id=v_user;
    update public.wallets set balance=balance+v_credit.amount,updated_at=now() where id=v_target and user_id=v_user;
    update public.wallet_income_credits set wallet_id=v_target where transaction_id=p_transaction and user_id=v_user;
  end if;
  update public."transaction" set source_wallet_id=v_target where id=p_transaction and user_id=v_user;
end $$;
revoke all on function public.offline_move_income_wallet(uuid,uuid) from public,anon,authenticated;
create function public.offline_apply_ledger(p_table text,p_local uuid,p_operation text,p jsonb)
returns void language plpgsql security definer set search_path='' as $$
declare v_user uuid:=auth.uid(); v_id uuid; v_result jsonb; v_exists boolean;
begin
  v_id := public.offline_remote_id(p_table,p_local);
  if p_table='transaction' then
    select exists(select 1 from public."transaction" where id=v_id and user_id=v_user) into v_exists;
    if p_operation='delete' then
      if v_exists then perform public.delete_finance_entry(v_id); end if;
    else
      if v_exists then
        perform public.update_finance_entry(v_id,p->>'title',coalesce(p->>'description',''),
          (p->>'amount')::bigint,(p->>'date')::timestamptz,p->>'transaction_type',
          public.offline_remote_id('categories',(p->>'category_id')::uuid),
          (p->>'source_wallet_id')::uuid,date_trunc('month',(p->>'date')::timestamptz)::date,
          coalesce((p->>'use_all_wallets')::boolean,false));
      else
        v_result := public.create_manual_finance_entry(p->>'title',coalesce(p->>'description',''),
          (p->>'amount')::bigint,(p->>'date')::timestamptz,p->>'transaction_type',
          public.offline_remote_id('categories',(p->>'category_id')::uuid),
          (p->>'source_wallet_id')::uuid,date_trunc('month',(p->>'date')::timestamptz)::date,
          coalesce((p->>'use_all_wallets')::boolean,false));
        v_id:=(v_result->>'id')::uuid;
        insert into public.offline_entity_aliases values(v_user,p_table,p_local,v_id);
      end if;
      if p->>'transaction_type'='income' then
        perform public.offline_move_income_wallet(v_id,(p->>'source_wallet_id')::uuid);
      end if;
    end if;
  elsif p_table='envelopes' then
    select exists(select 1 from public.envelopes where id=v_id and user_id=v_user) into v_exists;
    if p_operation='delete' then
      if v_exists then perform public.delete_funded_envelope(v_id); end if;
    elsif v_exists then
      perform public.update_funded_envelope(v_id,p->>'name',
        public.offline_remote_id('categories',(p->>'category_id')::uuid),
        (p->>'amount')::bigint,coalesce((p->>'repeats_monthly')::boolean,false));
    else
      if coalesce((p->>'repeats_monthly')::boolean,false) then
        v_result := public.fund_monthly_envelope(p->>'name',
          public.offline_remote_id('categories',(p->>'category_id')::uuid),
          (p->>'amount')::bigint,(p->>'period_month')::date,(p->>'funding_wallet_id')::uuid);
      else
        v_result := public.fund_envelope(p->>'name',
          public.offline_remote_id('categories',(p->>'category_id')::uuid),
          (p->>'amount')::bigint,(p->>'period_month')::date,(p->>'funding_wallet_id')::uuid);
      end if;
      v_id := (v_result->>'id')::uuid;
      update public.envelopes set repeats_monthly=coalesce((p->>'repeats_monthly')::boolean,false)
        where id=v_id and user_id=v_user;
      insert into public.offline_entity_aliases values(v_user,p_table,p_local,v_id);
    end if;
  elsif p_table='wallet_transfers' then
    perform public.create_manual_wallet_transfer(p_local,(p->>'from_wallet_id')::uuid,
      (p->>'to_wallet_id')::uuid,(p->>'amount')::bigint,
      (p->>'occurred_at')::timestamptz,coalesce(p->>'description',''));
  else raise exception 'unsupported_offline_operation'; end if;
end $$;
revoke all on function public.offline_apply_ledger(text,uuid,text,jsonb) from public,anon,authenticated;
commit;
