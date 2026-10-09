begin;

create table if not exists public.onboarding_wallet_presets (
  slug text primary key,
  name text not null,
  name_translations jsonb not null
);

insert into public.onboarding_wallet_presets(slug, name, name_translations)
values
  ('main', 'Main wallet', '{"en":"Main wallet","fr":"Portefeuille principal","mg":"Kitapom-bola fototra","de":"Hauptkonto","es":"Cartera principal","it":"Portafoglio principale"}'::jsonb),
  ('cash', 'Cash', '{"en":"Cash","fr":"Espèces","mg":"Vola mivantana","de":"Bargeld","es":"Efectivo","it":"Contanti"}'::jsonb),
  ('bank', 'Bank', '{"en":"Bank","fr":"Compte bancaire","mg":"Kaonty banky","de":"Bankkonto","es":"Cuenta bancaria","it":"Conto bancario"}'::jsonb),
  ('mobile', 'Mobile Money', '{"en":"Mobile Money","fr":"Mobile money","mg":"Mobile money","de":"Mobiles Geld","es":"Dinero móvil","it":"Denaro mobile"}'::jsonb)
on conflict (slug) do update set
  name = excluded.name,
  name_translations = excluded.name_translations;

revoke all on public.onboarding_wallet_presets from public, anon, authenticated;

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
  v_main_name text;
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
    select gen_random_uuid(), v_user,
      coalesce(p.name_translations->>p_language, p.name),
      p.emoji, p.color, p.icon_key, p.transaction_type
    from public.category_presets p where p.slug = any(p_categories)
    on conflict do nothing;

  select coalesce(p.name_translations->>p_language, p.name)
    into v_main_name from public.onboarding_wallet_presets p where p.slug = 'main';
  insert into public.wallets(user_id, name, is_default, currency_code)
    select v_user, v_main_name, true, 'MGA'
    where not exists(select 1 from public.wallets where user_id = v_user and is_default)
    on conflict do nothing;
  -- Rename only the signup-created default wallet; leave custom names and balances intact.
  update public.wallets w set name = v_main_name
    where w.user_id = v_user and w.is_default and w.name = 'Main wallet'
      and not exists (
        select 1 from public.wallets other
        where other.user_id = v_user and other.id <> w.id
          and lower(other.name) = lower(v_main_name)
      );
  insert into public.wallets(user_id, name, icon_key, currency_code)
    select v_user, coalesce(p.name_translations->>p_language, p.name),
      p.slug, 'MGA'
    from public.onboarding_wallet_presets p
    where p.slug = any(p_wallets) and p.slug <> 'main'
    on conflict do nothing;

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
