do $$
declare
  v_user uuid := gen_random_uuid();
  v_category uuid := gen_random_uuid();
  v_wallet uuid := gen_random_uuid();
  v_other_wallet uuid := gen_random_uuid();
  v_envelope uuid := gen_random_uuid();
  v_tx uuid := gen_random_uuid();
begin
  insert into public.wallets(id,user_id,balance,is_default)
  values (v_wallet,v_user,0,true);
  insert into public."transaction"(
    id,user_id,transaction_type,amount,category_id,ledger_month
  ) values (v_tx,v_user,'expense',30,v_category,'2026-10-01');
  perform public.route_expense_funds(v_tx,null,false);
  if (select balance from public.wallets where id=v_wallet) <> -30 then
    raise exception 'zero-income expense did not overdraw default wallet';
  end if;
  if (select amount from public.transaction_wallet_debits
      where transaction_id=v_tx and wallet_id=v_wallet) <> 30 then
    raise exception 'wallet debit was not recorded';
  end if;

  update public.wallets set balance=0 where id=v_wallet;
  insert into public.envelopes(
    id,user_id,category_id,period_month,name,remaining_amount
  ) values (v_envelope,v_user,v_category,'2026-10-01','Food',25);
  v_tx := gen_random_uuid();
  insert into public."transaction"(
    id,user_id,transaction_type,amount,category_id,ledger_month
  ) values (v_tx,v_user,'expense',20,v_category,'2026-10-01');
  perform public.route_expense_funds(v_tx,null,false);
  if (select balance from public.wallets where id=v_wallet) <> 0 then
    raise exception 'funded envelope expense changed wallet balance';
  end if;
  if (select remaining_amount from public.envelopes where id=v_envelope) <> 5 then
    raise exception 'funded envelope balance was not used';
  end if;
  if exists (select 1 from public.transaction_wallet_debits
      where transaction_id=v_tx) then
    raise exception 'funded envelope expense debited wallet';
  end if;

  v_tx := gen_random_uuid();
  insert into public."transaction"(
    id,user_id,transaction_type,amount,category_id,ledger_month
  ) values (v_tx,v_user,'expense',10,v_category,'2026-10-01');
  perform public.route_expense_funds(v_tx,null,false);
  if (select balance from public.wallets where id=v_wallet) <> -5 then
    raise exception 'envelope remainder did not overdraw wallet';
  end if;
  if (select envelope_amount_used from public."transaction" where id=v_tx) <> 5 then
    raise exception 'envelope usage was not recorded';
  end if;

  update public.wallets set balance=0 where id=v_wallet;
  v_tx := gen_random_uuid();
  insert into public."transaction"(
    id,user_id,transaction_type,amount,category_id,ledger_month
  ) values (v_tx,v_user,'expense',12,gen_random_uuid(),'2026-10-01');
  perform public.route_expense_funds(v_tx,null,true);
  if (select balance from public.wallets where id=v_wallet) <> -12 then
    raise exception 'all-wallet expense did not overdraw default wallet';
  end if;

  update public.wallets set balance=0 where id=v_wallet;
  insert into public.wallets(id,user_id,balance,is_default)
  values (v_other_wallet,v_user,50,false);
  v_tx := gen_random_uuid();
  insert into public."transaction"(
    id,user_id,transaction_type,amount,category_id,ledger_month
  ) values (v_tx,v_user,'expense',30,gen_random_uuid(),'2026-10-01');
  begin
    perform public.route_expense_funds(v_tx,null,false);
    raise exception 'expected consent to use another funded wallet';
  exception when others then
    if sqlerrm not like 'wallet_consent_required:%' then raise; end if;
  end;
  perform public.route_expense_funds(v_tx,null,true);
  if (select balance from public.wallets where id=v_wallet) <> 0 or
      (select balance from public.wallets where id=v_other_wallet) <> 20 then
    raise exception 'consented all-wallet payment debited incorrectly';
  end if;
end;
$$;
