begin;

create or replace function public.import_guest_snapshot_v2(
  p_guest_id uuid, p_snapshot jsonb
) returns boolean
language plpgsql security definer set search_path = ''
as $$
declare
  v_user uuid := auth.uid();
  v_imported boolean;
  v_item jsonb;
  v_from_name text;
  v_to_name text;
  v_from_id uuid;
  v_to_id uuid;
begin
  if v_user is null then raise exception 'authentication_required'; end if;
  v_imported := public.import_guest_snapshot(p_guest_id,p_snapshot);
  if jsonb_array_length(coalesce(p_snapshot->'wallet_transfers','[]'::jsonb))
      > 50000 then
    raise exception 'guest_snapshot_too_large';
  end if;
  for v_item in select value from jsonb_array_elements(
      coalesce(p_snapshot->'wallet_transfers','[]'::jsonb)) loop
    select value->>'name' into v_from_name
    from jsonb_array_elements(p_snapshot->'wallets')
    where value->>'id' = v_item->>'from_wallet_id' limit 1;
    select value->>'name' into v_to_name
    from jsonb_array_elements(p_snapshot->'wallets')
    where value->>'id' = v_item->>'to_wallet_id' limit 1;
    select id into v_from_id from public.wallets
    where user_id=v_user and lower(name)=lower(v_from_name) limit 1;
    select id into v_to_id from public.wallets
    where user_id=v_user and lower(name)=lower(v_to_name) limit 1;
    if v_from_id is null or v_to_id is null or v_from_id=v_to_id then
      raise exception 'invalid_guest_transfer_wallet';
    end if;
    insert into public.wallet_transfers(
      id,user_id,from_wallet_id,to_wallet_id,amount,currency_code,
      description,occurred_at,created_at
    ) values (
      (v_item->>'id')::uuid,v_user,v_from_id,v_to_id,
      (v_item->>'amount')::bigint,
      coalesce(v_item->>'currency_code','MGA'),
      coalesce(v_item->>'description',''),
      (v_item->>'occurred_at')::timestamptz,
      coalesce((v_item->>'created_at')::timestamptz,now())
    ) on conflict (id) do nothing;
    if not exists (select 1 from public.wallet_transfers
      where id=(v_item->>'id')::uuid and user_id=v_user) then
      raise exception 'guest_transfer_id_conflict';
    end if;
  end loop;
  return v_imported;
end;
$$;
revoke all on function public.import_guest_snapshot_v2(uuid,jsonb)
  from public, anon;
grant execute on function public.import_guest_snapshot_v2(uuid,jsonb)
  to authenticated;

commit;
