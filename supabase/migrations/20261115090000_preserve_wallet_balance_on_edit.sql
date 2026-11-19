begin;
create or replace function public.offline_apply_record(p_table text,p_id uuid,p_operation text,p jsonb)
returns void language plpgsql security definer set search_path='' as $$
declare v_user uuid:=auth.uid(); v_exists boolean; v_meta jsonb;
begin
  if p_table='wallets' then
    if exists(select 1 from public.wallets where id=p_id and user_id<>v_user) then
      raise exception 'offline_ownership_violation'; end if;
    if p_operation='delete' then
      perform public.delete_wallets(array[p_id]);
    elsif p_operation='default' then perform public.set_default_wallet(p_id);
    else
      insert into public.wallets(id,user_id,name,balance,currency_code,icon_key,is_default)
        values(p_id,v_user,p->>'name',coalesce((p->>'balance')::bigint,0),'MGA',coalesce(p->>'icon_key','wallet'),false)
        on conflict(id) do update set name=excluded.name,updated_at=now()
        where public.wallets.user_id=v_user;
    end if;
  elsif p_table='categories' then
    if exists(select 1 from public.categories where id=p_id and user_id<>v_user) then
      raise exception 'offline_ownership_violation'; end if;
    if p_operation='delete' then
      delete from public.categories where id=p_id and user_id=v_user;
    else
      insert into public.categories(id,user_id,name,transaction_type,emoji,color,icon_key)
        values(p_id,v_user,p->>'name',coalesce(p->>'transaction_type','expense'),
          coalesce(p->>'emoji','🧾'),p->>'color',coalesce(p->>'icon_key','other'))
        on conflict(id) do update set name=excluded.name,emoji=excluded.emoji,
          color=excluded.color,icon_key=excluded.icon_key where public.categories.user_id=v_user;
    end if;
  elsif p_table='user' then
    if p_id<>v_user then raise exception 'offline_ownership_violation'; end if;
    if p ? 'currency_code' and (p->>'currency_code') !~ '^[A-Z]{3}$' then
      raise exception 'invalid_currency'; end if;
    update public."user" set username=coalesce(p->>'username',username),
      currency_code=coalesce(p->>'currency_code',currency_code) where user_id=v_user;
    v_meta := '{}'::jsonb;
    if p ? 'language_code' then
      if p->>'language_code' not in ('en','fr','mg','de','es','it') then raise exception 'invalid_language'; end if;
      v_meta := v_meta || jsonb_build_object('language_code',p->>'language_code');
    end if;
    if p ? 'theme_mode' then
      if p->>'theme_mode' not in ('light','dark','system') then raise exception 'invalid_theme'; end if;
      v_meta := v_meta || jsonb_build_object('theme_mode',p->>'theme_mode');
    end if;
    if v_meta<>'{}'::jsonb then
      update auth.users set raw_user_meta_data=coalesce(raw_user_meta_data,'{}') || v_meta where id=v_user;
    end if;
  elsif p_table='notification_settings' then
    insert into public.notification_settings(user_id,notifications_enabled,reminders_enabled,warnings_enabled,
      reminder_hour,reminder_minute,timezone_offset_minutes,warning_threshold)
      values(v_user,(p->>'notifications_enabled')::boolean,(p->>'reminders_enabled')::boolean,
      (p->>'warnings_enabled')::boolean,(p->>'reminder_hour')::int,(p->>'reminder_minute')::int,
      (p->>'timezone_offset_minutes')::int,(p->>'warning_threshold')::numeric)
      on conflict(user_id) do update set notifications_enabled=excluded.notifications_enabled,
      reminders_enabled=excluded.reminders_enabled,warnings_enabled=excluded.warnings_enabled,
      reminder_hour=excluded.reminder_hour,reminder_minute=excluded.reminder_minute,
      timezone_offset_minutes=excluded.timezone_offset_minutes,warning_threshold=excluded.warning_threshold,
      updated_at=now();
  elsif p_table='finance_notifications' then
    update public.finance_notifications set is_read=true where user_id=v_user and
      (id=p_id or (transaction_id=public.offline_remote_id('transaction',(p->>'transaction_id')::uuid)
        and notification_type=p->>'notification_type'));
  else
    perform public.offline_apply_ledger(p_table,p_id,p_operation,p);
  end if;
end $$;
revoke all on function public.offline_apply_record(text,uuid,text,jsonb) from public,anon,authenticated;
commit;
