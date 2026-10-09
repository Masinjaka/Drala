do $$
declare
  v_user uuid := gen_random_uuid();
begin
  insert into public.notification_settings(user_id) values (v_user);
  if (select language_code from public.notification_settings
      where user_id = v_user) <> 'en' then
    raise exception 'new notification settings did not default to English';
  end if;
  update public.notification_settings set language_code = 'mg'
  where user_id = v_user;
  if (select language_code from public.notification_settings
      where user_id = v_user) <> 'mg' then
    raise exception 'selected notification language was not saved';
  end if;
end;
$$;
