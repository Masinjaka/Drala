begin;

create or replace function public.delete_wallets(p_wallet_ids uuid[])
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_user uuid := auth.uid();
  v_ids uuid[];
  v_count integer;
begin
  if v_user is null then raise exception 'unauthorized'; end if;
  perform public.lock_envelope_funding();
  select array_agg(distinct id) into v_ids from unnest(p_wallet_ids) id;
  if coalesce(cardinality(v_ids), 0) = 0 then return; end if;
  perform 1 from public.wallets
    where user_id = v_user and id = any(v_ids) order by id for update;
  select count(*) into v_count from public.wallets
    where user_id = v_user and id = any(v_ids);
  if v_count <> cardinality(v_ids) then raise exception 'wallet_not_found'; end if;
  if exists(select 1 from public.wallets where id = any(v_ids) and is_default) then
    raise exception 'default_wallet_cannot_be_deleted';
  end if;
  begin
    delete from public.wallets where user_id = v_user and id = any(v_ids);
  exception when foreign_key_violation then
    raise exception 'wallet_in_use';
  end;
end;
$$;

create or replace function public.delete_funded_envelopes(p_envelope_ids uuid[])
returns void language plpgsql security definer set search_path = '' as $$
declare
  v_user uuid := auth.uid();
  v_ids uuid[];
  v_id uuid;
  v_count integer;
begin
  if v_user is null then raise exception 'unauthorized'; end if;
  perform public.lock_envelope_funding();
  select array_agg(distinct id order by id) into v_ids from unnest(p_envelope_ids) id;
  if coalesce(cardinality(v_ids), 0) = 0 then return; end if;
  perform 1 from public.envelopes
    where user_id = v_user and id = any(v_ids) order by id for update;
  select count(*) into v_count from public.envelopes
    where user_id = v_user and id = any(v_ids);
  if v_count <> cardinality(v_ids) then raise exception 'envelope_not_found'; end if;
  -- Match transfer lock ordering before refunding several funding wallets.
  perform 1 from public.wallets
    where user_id = v_user and id in (
      select funding_wallet_id from public.envelopes
      where user_id = v_user and id = any(v_ids)
    ) order by id for update;
  foreach v_id in array v_ids loop
    perform public.delete_funded_envelope(v_id);
  end loop;
end;
$$;

revoke all on function public.delete_wallets(uuid[]) from public, anon;
revoke all on function public.delete_funded_envelopes(uuid[]) from public, anon;
grant execute on function public.delete_wallets(uuid[]) to authenticated;
grant execute on function public.delete_funded_envelopes(uuid[]) to authenticated;

commit;
