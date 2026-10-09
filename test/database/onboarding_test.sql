set test.user_id = '00000000-0000-0000-0000-000000000001';
select public.complete_onboarding('EUR','fr',array['food'],array['cash','cash','bank']);
-- Retrying must not change completed choices or add duplicates.
select public.complete_onboarding('USD','en',array['salary'],array['mobile']);
do $$
begin
  if (select count(*) from public.wallets) <> 3 then raise exception 'Duplicate wallets'; end if;
  if (select count(*) from public.categories) <> 1 then raise exception 'Duplicate categories'; end if;
  if (select name from public.categories where user_id = auth.uid()) <> 'Repas et boissons' then
    raise exception 'Selected language was not used for category name'; end if;
  if (select count(*) from public.category_presets
      where not name_translations ?& array['en','fr','mg','de','es','it']) <> 0 then
    raise exception 'Preset translations are incomplete'; end if;
  if (select balance from public.wallets where is_default) <> 12345 then
    raise exception 'Existing funds changed'; end if;
  if exists(select 1 from public.wallets where currency_code <> 'MGA') then
    raise exception 'Ledger base currency changed'; end if;
  if (select currency_code from public."user" where user_id = auth.uid()) <> 'EUR' then
    raise exception 'Display currency not saved'; end if;
  if (select raw_user_meta_data->>'onboarding_required' from auth.users where id = auth.uid()) <> 'false' then
    raise exception 'Completion not saved'; end if;
  if (select raw_user_meta_data->>'onboarding_required' from auth.users where id <> auth.uid()) <> 'true' then
    raise exception 'Another account modified'; end if;
end $$;
set test.user_id = '00000000-0000-0000-0000-000000000002';
do $$
begin
  begin
    perform public.complete_onboarding('USD','en',array['missing'],array['cash']);
    raise exception 'Invalid preset accepted';
  exception when raise_exception then
    if sqlerrm <> 'Invalid starter selection' then raise; end if;
  end;
  if exists(select 1 from public.wallets where user_id = auth.uid()) then
    raise exception 'Failed transaction leaked wallets'; end if;
  if (select currency_code from public."user" where user_id = auth.uid()) <> 'MGA' then
    raise exception 'Failed transaction changed currency'; end if;
end $$;
select public.complete_onboarding('USD','en',array[]::text[],array[]::text[]);
do $$
begin
  if (select count(*) from public.wallets where user_id = auth.uid() and is_default) <> 1 then
    raise exception 'Empty selection must retain a main wallet'; end if;
end $$;
set test.user_id = '';
do $$
begin
  begin
    perform public.complete_onboarding('USD','en',array[]::text[],array[]::text[]);
    raise exception 'Anonymous access accepted';
  exception when raise_exception then
    if sqlerrm <> 'Authentication required' then raise; end if;
  end;
end $$;
