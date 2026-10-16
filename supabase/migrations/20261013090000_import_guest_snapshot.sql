begin;
create table public.guest_imports (
  user_id uuid not null references auth.users(id) on delete cascade,
  guest_id uuid not null,
  imported_at timestamptz not null default now(),
  primary key (user_id, guest_id)
);
alter table public.guest_imports enable row level security;
revoke all on public.guest_imports from public, anon, authenticated;
create or replace function public.import_guest_snapshot(
  p_guest_id uuid, p_snapshot jsonb
) returns boolean
language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_item jsonb; v_profile jsonb; v_notifications jsonb;
  v_wallet_map jsonb := '{}'::jsonb; v_category_map jsonb := '{}'::jsonb;
  v_envelope_map jsonb := '{}'::jsonb;
  v_id uuid; v_category uuid; v_wallet uuid; v_envelope uuid; v_existing_wallet uuid;
  v_guest_default uuid; v_amount bigint;
  v_currency text; v_existing_currency text;
begin
  if v_user is null then raise exception 'authentication_required'; end if;
  if p_guest_id is null or jsonb_typeof(p_snapshot) <> 'object' then
    raise exception 'invalid_guest_snapshot'; end if;
  if jsonb_array_length(coalesce(p_snapshot->'wallets','[]'::jsonb)) > 1000
    or jsonb_array_length(coalesce(p_snapshot->'categories','[]'::jsonb)) > 1000
    or jsonb_array_length(coalesce(p_snapshot->'envelopes','[]'::jsonb)) > 10000
    or jsonb_array_length(coalesce(p_snapshot->'wallet_debits','[]'::jsonb)) > 50000
    or jsonb_array_length(coalesce(p_snapshot->'transactions','[]'::jsonb)) > 50000 then
    raise exception 'guest_snapshot_too_large'; end if;
  insert into public.guest_imports(user_id, guest_id)
  values(v_user, p_guest_id) on conflict do nothing;
  if not found then return false; end if;
  for v_item in select value from jsonb_array_elements(
    coalesce(p_snapshot->'wallets','[]'::jsonb)) loop
    v_currency := coalesce(v_item->>'currency_code','MGA');
    select id, currency_code into v_id, v_existing_currency
    from public.wallets where user_id = v_user
      and lower(name) = lower(v_item->>'name') limit 1;
    if v_id is not null then
      if v_existing_currency <> v_currency then
        raise exception 'wallet_currency_conflict:%', v_item->>'name'; end if;
      update public.wallets set balance = balance + (v_item->>'balance')::bigint,
        updated_at = now() where id = v_id;
    else
      insert into public.wallets(id,user_id,name,balance,currency_code,
        icon_key,is_default,created_at,updated_at)
      values((v_item->>'id')::uuid,v_user,left(v_item->>'name',80),
        (v_item->>'balance')::bigint,v_currency,
        coalesce(v_item->>'icon_key','wallet'),false,
        coalesce((v_item->>'created_at')::timestamptz,now()),now())
      returning id into v_id;
    end if;
    v_wallet_map := v_wallet_map || jsonb_build_object(v_item->>'id',v_id);
    if (v_item->>'is_default')::boolean then v_guest_default := v_id; end if;
  end loop;
  if v_guest_default is not null then
    update public.wallets set is_default = false where user_id = v_user and is_default;
    update public.wallets set is_default = true where id = v_guest_default; end if;
  for v_item in select value from jsonb_array_elements(
    coalesce(p_snapshot->'categories','[]'::jsonb)) loop
    select id into v_id from public.categories where user_id = v_user
      and lower(name) = lower(v_item->>'name')
      and transaction_type = v_item->>'transaction_type' limit 1;
    if v_id is null then
      insert into public.categories(id,user_id,name,emoji,color,icon_key,
        transaction_type)
      values((v_item->>'id')::uuid,v_user,v_item->>'name',
        coalesce(v_item->>'emoji','🧾'),
        coalesce(v_item->>'color','FF9E9E9E'),
        coalesce(v_item->>'icon_key','other'),
        v_item->>'transaction_type') returning id into v_id;
    end if;
    v_category_map := v_category_map || jsonb_build_object(v_item->>'id',v_id);
  end loop;
  for v_item in select value from jsonb_array_elements(
    coalesce(p_snapshot->'envelopes','[]'::jsonb))
    order by value->>'period_month' loop
    v_category := (v_category_map->>(v_item->>'category_id'))::uuid;
    v_wallet := (v_wallet_map->>(v_item->>'funding_wallet_id'))::uuid;
    if v_category is null or v_wallet is null then
      raise exception 'invalid_guest_envelope_reference'; end if;
    select id,funding_wallet_id into v_id,v_existing_wallet
    from public.envelopes where user_id = v_user
      and category_id = v_category
      and period_month = (v_item->>'period_month')::date;
    if v_id is not null and v_existing_wallet is distinct from v_wallet then
      raise exception 'guest_envelope_funding_conflict'; end if;
    if coalesce((v_item->>'repeats_monthly')::boolean,false) then
      update public.envelopes set repeats_monthly = false
      where user_id = v_user and category_id = v_category
        and repeats_monthly and id is distinct from v_id;
    end if;
    if v_id is null then
      insert into public.envelopes(id,user_id,category_id,name,amount,
        remaining_amount,overspent_amount,period_month,funding_wallet_id,
        currency_code,repeats_monthly,created_at,updated_at)
      values((v_item->>'id')::uuid,v_user,v_category,v_item->>'name',
        (v_item->>'amount')::bigint,(v_item->>'remaining_amount')::bigint,
        coalesce((v_item->>'overspent_amount')::bigint,0),
        (v_item->>'period_month')::date,v_wallet,
        coalesce(v_item->>'currency_code','MGA'),
        coalesce((v_item->>'repeats_monthly')::boolean,false),
        coalesce((v_item->>'created_at')::timestamptz,now()),now())
      returning id into v_id;
    else
      update public.envelopes set amount = amount + (v_item->>'amount')::bigint,
        remaining_amount = remaining_amount +
          (v_item->>'remaining_amount')::bigint,
        overspent_amount = overspent_amount +
          coalesce((v_item->>'overspent_amount')::bigint,0),
        repeats_monthly = repeats_monthly or
          coalesce((v_item->>'repeats_monthly')::boolean,false),
        updated_at = now() where id = v_id;
    end if;
    v_envelope_map := v_envelope_map || jsonb_build_object(v_item->>'id',v_id);
  end loop;
  for v_item in select value from jsonb_array_elements(
    coalesce(p_snapshot->'transactions','[]'::jsonb)) loop
    v_category := (v_category_map->>(v_item->>'category_id'))::uuid;
    v_wallet := (v_wallet_map->>(v_item->>'source_wallet_id'))::uuid;
    v_envelope := (v_envelope_map->>(v_item->>'envelope_id'))::uuid;
    v_amount := (v_item->>'amount')::bigint;
    if v_item->>'category_id' is not null and v_category is null or
       v_item->>'source_wallet_id' is not null and v_wallet is null or
       v_item->>'envelope_id' is not null and v_envelope is null then
      raise exception 'invalid_guest_transaction_reference';
    end if;
    insert into public."transaction"(id,user_id,title,description,amount,
      transaction_type,date,ledger_month,currency_code,
      category_id,source_wallet_id,envelope_id,envelope_amount_used,created_at)
    values((v_item->>'id')::uuid,v_user,v_item->>'title',
      coalesce(v_item->>'description',''),v_amount,
      v_item->>'transaction_type',(v_item->>'date')::timestamptz,
      date_trunc('month',(v_item->>'date')::timestamptz)::date,
      coalesce(v_item->>'currency_code','MGA'),v_category,v_wallet,v_envelope,
      coalesce((v_item->>'envelope_amount_used')::bigint,0),
      coalesce((v_item->>'created_at')::timestamptz,now()));
    if v_item->>'transaction_type' = 'income' and v_wallet is not null then
      insert into public.wallet_income_credits(
        transaction_id,wallet_id,user_id,amount,currency_code)
      values((v_item->>'id')::uuid,v_wallet,v_user,v_amount,
        coalesce(v_item->>'currency_code','MGA'));
    end if;
  end loop;
  for v_item in select value from jsonb_array_elements(
    coalesce(p_snapshot->'wallet_debits','[]'::jsonb)) loop
    v_wallet := (v_wallet_map->>(v_item->>'wallet_id'))::uuid;
    if v_wallet is null then raise exception 'invalid_guest_debit_wallet'; end if;
    if not exists (select 1 from public."transaction"
      where id=(v_item->>'transaction_id')::uuid and user_id=v_user) then
      raise exception 'invalid_guest_debit_transaction'; end if;
    insert into public.transaction_wallet_debits(
      transaction_id,wallet_id,user_id,amount)
    values((v_item->>'transaction_id')::uuid,v_wallet,v_user,
      (v_item->>'amount')::bigint);
  end loop;
  v_profile := coalesce(p_snapshot->'profile','{}'::jsonb);
  update public."user" set currency_code = coalesce(
    v_profile->>'currency_code',currency_code) where user_id = v_user;
  if not found then raise exception 'profile_missing'; end if;
  v_notifications := p_snapshot->'notifications';
  if v_notifications is not null then
    insert into public.notification_settings(user_id,notifications_enabled,
      reminders_enabled,warnings_enabled,reminder_hour,reminder_minute,
      timezone_offset_minutes,warning_threshold,language_code)
    values(v_user,(v_notifications->>'notifications_enabled')::boolean,
      (v_notifications->>'reminders_enabled')::boolean,
      (v_notifications->>'warnings_enabled')::boolean,
      (v_notifications->>'reminder_hour')::integer,
      (v_notifications->>'reminder_minute')::integer,
      (v_notifications->>'timezone_offset_minutes')::integer,
      (v_notifications->>'warning_threshold')::numeric,
      v_profile->>'language_code')
    on conflict(user_id) do update set
      notifications_enabled = excluded.notifications_enabled,
      reminders_enabled = excluded.reminders_enabled,
      warnings_enabled = excluded.warnings_enabled,
      reminder_hour = excluded.reminder_hour,
      reminder_minute = excluded.reminder_minute,
      timezone_offset_minutes = excluded.timezone_offset_minutes,
      warning_threshold = excluded.warning_threshold,
      language_code = excluded.language_code,updated_at = now();
  end if;
  update auth.users set raw_user_meta_data =
    (coalesce(raw_user_meta_data,'{}'::jsonb) - 'onboarding_draft') ||
    jsonb_build_object('onboarding_required',false,
      'language_code',coalesce(v_profile->>'language_code','en'),
      'theme_mode',coalesce(v_profile->>'theme_mode','system'))
    where id = v_user;
  return true;
end;
$$;
revoke all on function public.import_guest_snapshot(uuid,jsonb)
  from public, anon;
grant execute on function public.import_guest_snapshot(uuid,jsonb)
  to authenticated;
commit;
