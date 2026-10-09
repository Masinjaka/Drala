do $$
declare
  v_user uuid := gen_random_uuid();
  v_category uuid := gen_random_uuid();
  v_wallet uuid := gen_random_uuid();
  v_request uuid := gen_random_uuid();
begin
  insert into public.wallets(id,user_id,balance,is_default)
  values (v_wallet,v_user,0,true);
  perform public.complete_finance_request(
    v_request,v_user,'{}'::jsonb,
    jsonb_build_array(jsonb_build_object(
      'amount',40,'category_id',v_category
    )),
    '[]'::jsonb,'[]'::jsonb,null,null,null,'2026-10-01',false
  );
  if (select balance from public.wallets where id=v_wallet) <> -40 then
    raise exception 'AI expense did not overdraw default wallet';
  end if;
  if (select count(*) from public.transaction_wallet_debits
      where wallet_id=v_wallet and amount=40) <> 1 then
    raise exception 'AI expense debit was not recorded';
  end if;
end;
$$;
