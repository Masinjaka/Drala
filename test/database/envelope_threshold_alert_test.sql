do $$
declare
  v_user uuid := gen_random_uuid();
  v_category uuid := gen_random_uuid();
  v_wallet uuid := gen_random_uuid();
  v_envelope uuid := gen_random_uuid();
  v_tx uuid;
  v_amount bigint;
begin
  insert into public.wallets(id,user_id,balance,is_default)
  values (v_wallet,v_user,0,true);
  insert into public.notification_settings(user_id,warning_threshold)
  values (v_user,0.9);
  insert into public.envelopes(
    id,user_id,category_id,period_month,name,amount,remaining_amount
  ) values (v_envelope,v_user,v_category,'2026-10-01','Food',100,100);
  for v_amount in select unnest(array[91::bigint,9::bigint,10::bigint]) loop
    v_tx := gen_random_uuid();
    insert into public."transaction"(
      id,user_id,transaction_type,amount,category_id,ledger_month
    ) values (v_tx,v_user,'expense',v_amount,v_category,'2026-10-01');
    perform public.route_expense_funds(v_tx,null,false);
  end loop;
  if (select count(*) from public.finance_notifications
      where user_id=v_user) <> 3 then
    raise exception 'expected near, reached, and exceeded alerts';
  end if;
  if (select count(distinct notification_type) from public.finance_notifications
      where user_id=v_user) <> 3 then
    raise exception 'threshold alert types were incorrect';
  end if;
end;
$$;
