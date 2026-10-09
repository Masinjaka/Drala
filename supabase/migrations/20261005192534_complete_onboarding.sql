begin;

-- Complete setup atomically. Lock the account so retries cannot duplicate data.
create or replace function public.complete_onboarding(
  p_currency text, p_language text, p_categories text[], p_wallets text[]
) returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_metadata jsonb;
begin
  if v_user is null then raise exception 'Authentication required'; end if;
  select raw_user_meta_data into v_metadata from auth.users
    where id = v_user for update;
  if coalesce((v_metadata->>'onboarding_required')::boolean, false) = false then
    return;
  end if;
  if p_currency is null or p_currency !~ '^[A-Z]{3}$' then
    raise exception 'Invalid currency';
  end if;
  if p_language is null or p_language not in ('en','fr','mg','de','es','it') then
    raise exception 'Invalid language';
  end if;
  if p_categories is null or p_wallets is null or exists (
    select 1 from unnest(p_categories) s
    where not exists (select 1 from public.category_presets p where p.slug = s)
  ) or exists (select 1 from unnest(p_wallets) s
    where s not in ('cash','bank','mobile')) then
    raise exception 'Invalid starter selection';
  end if;

  update public."user" set currency_code = p_currency where user_id = v_user;
  if not found then raise exception 'Profile missing'; end if;
  insert into public.categories(id, user_id, name, emoji, color, icon_key, transaction_type)
    select gen_random_uuid(), v_user, p.name, p.emoji, p.color, p.icon_key, p.transaction_type
    from public.category_presets p where p.slug = any(p_categories)
    on conflict do nothing;

  -- The signup trigger supplies the main wallet. Preserve its balance and name.
  insert into public.wallets(user_id, name, is_default, currency_code)
    select v_user, 'Main wallet', true, 'MGA'
    where not exists(select 1 from public.wallets where user_id = v_user and is_default)
    on conflict do nothing;
  insert into public.wallets(user_id, name, icon_key, currency_code)
    select v_user, case s when 'cash' then 'Cash' when 'bank' then 'Bank account'
      else 'Mobile money' end, s, 'MGA'
    from (select distinct unnest(p_wallets) as s) selected
    on conflict do nothing;
  -- Wallet balances are stored in the app's base currency (MGA), as elsewhere.
  update auth.users set raw_user_meta_data =
    (coalesce(raw_user_meta_data, '{}'::jsonb) - 'onboarding_draft') ||
    jsonb_build_object('onboarding_required', false, 'language_code', p_language)
    where id = v_user;
end;
$$;
revoke all on function public.complete_onboarding(text,text,text[],text[])
  from public, anon;
grant execute on function public.complete_onboarding(text,text,text[],text[])
  to authenticated;
commit;
