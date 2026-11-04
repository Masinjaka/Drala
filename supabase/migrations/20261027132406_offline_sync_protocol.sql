begin;
create function public.apply_offline_batch(p_batch_id uuid,p_revision bigint,p_operations jsonb)
returns bigint language plpgsql security definer set search_path='' as $$
declare v_user uuid:=auth.uid(); v_revision bigint; v_receipt public.offline_batch_receipts%rowtype;
  v_op jsonb;
begin
  if v_user is null then raise exception 'unauthorized'; end if;
  if p_batch_id is null or p_revision is null or jsonb_typeof(p_operations) is distinct from 'array'
    or jsonb_array_length(p_operations) not between 1 and 50
    or octet_length(p_operations::text)>524288 then raise exception 'invalid_offline_batch'; end if;
  perform public.lock_envelope_funding();
  perform public.renew_monthly_envelopes(current_date);
  insert into public.offline_account_revisions(user_id) values(v_user) on conflict do nothing;
  select revision into v_revision from public.offline_account_revisions where user_id=v_user for update;
  select * into v_receipt from public.offline_batch_receipts where user_id=v_user and batch_id=p_batch_id;
  if found then
    if v_receipt.operations<>p_operations then raise exception 'offline_batch_id_conflict'; end if;
    return v_receipt.revision;
  end if;
  if v_revision<>p_revision then raise exception 'offline_sync_conflict'; end if;
  for v_op in select value from jsonb_array_elements(p_operations) loop
    if v_op->>'operation' is null or v_op->>'operation' not in ('upsert','delete','default','read')
      or v_op->>'record_id' is null or jsonb_typeof(v_op->'payload') is distinct from 'object'
    then raise exception 'invalid_offline_operation'; end if;
    perform public.offline_apply_record(v_op->>'table',(v_op->>'record_id')::uuid,
      v_op->>'operation',v_op->'payload');
  end loop;
  select revision into v_revision from public.offline_account_revisions where user_id=v_user;
  insert into public.offline_batch_receipts(user_id,batch_id,operations,revision)
    values(v_user,p_batch_id,p_operations,v_revision);
  return v_revision;
end $$;
create function public.offline_project_row(p_user uuid,p_table text,p jsonb) returns jsonb
language plpgsql stable security definer set search_path='' as $$
declare v_column text; v_kind text; v_wallet uuid;
begin
  if p_table='transaction' and p->>'transaction_type'='income' and p->>'source_wallet_id' is null then
    select wallet_id into v_wallet from public.wallet_income_credits
      where transaction_id=(p->>'id')::uuid and user_id=p_user;
    if v_wallet is not null then p:=jsonb_set(p,'{source_wallet_id}',to_jsonb(v_wallet)); end if;
  end if;
  if p_table in ('transaction','envelopes') then
    p:=jsonb_set(p,'{id}',to_jsonb(public.offline_local_id(p_user,p_table,(p->>'id')::uuid)));
  end if;
  foreach v_column in array array['transaction_id','envelope_id','category_id'] loop
    if p->>v_column is not null then
      v_kind:=case v_column when 'transaction_id' then 'transaction'
        when 'envelope_id' then 'envelopes' else 'categories' end;
      p:=jsonb_set(p,array[v_column],to_jsonb(public.offline_local_id(p_user,v_kind,(p->>v_column)::uuid)));
    end if;
  end loop;
  return p;
end $$;
create function public.offline_pull_page(p_table text,p_after text default null,p_limit int default 250)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare v_user uuid:=auth.uid(); v_key text; v_result jsonb;
begin
  if v_user is null then raise exception 'unauthorized'; end if;
  if p_table is null or p_table not in ('wallets','categories','envelopes','transaction','transaction_wallet_debits',
    'wallet_transfers','finance_notifications','notification_settings','user')
    or p_limit is null or p_limit not between 1 and 500 then raise exception 'invalid_offline_page'; end if;
  v_key:=case when p_table='transaction_wallet_debits' then 't.transaction_id::text || '':'' || t.wallet_id::text'
    when p_table in ('user','notification_settings') then 't.user_id::text' else 't.id::text' end;
  execute format('select coalesce(jsonb_agg(public.offline_project_row($1,$2,to_jsonb(p))),''[]''::jsonb)
    from (select t.*,%s as _key from public.%I t where t.user_id=$1
      and ($3 is null or %s>$3) order by %s limit $4) p',v_key,p_table,v_key,v_key)
    into v_result using v_user,p_table,p_after,p_limit;
  return v_result;
end $$;
revoke all on function public.offline_project_row(uuid,text,jsonb) from public,anon,authenticated;
revoke all on function public.apply_offline_batch(uuid,bigint,jsonb),
  public.offline_pull_page(text,text,int) from public,anon;
grant execute on function public.apply_offline_batch(uuid,bigint,jsonb),
  public.offline_pull_page(text,text,int) to authenticated;
create function public.offline_pull_changes(p_since bigint,p_until bigint,p_after bigint default null,p_limit int default 250)
returns jsonb language plpgsql stable security definer set search_path='' as $$
declare v_user uuid:=auth.uid(); v_rows jsonb;
begin
  if v_user is null then raise exception 'unauthorized'; end if;
  if p_since is null or p_until is null or p_since<0 or p_until<p_since or p_limit is null or p_limit not between 1 and 500 then
    raise exception 'invalid_offline_cursor'; end if;
  select coalesce(jsonb_agg(jsonb_build_object('table',c.table_name,'revision',c.revision,
    'payload',public.offline_project_row(v_user,c.table_name,c.payload) ||
      jsonb_build_object('_key',c.record_key,'_deleted',c.deleted)) order by c.revision),'[]') into v_rows
    from (select * from public.offline_changes where user_id=v_user
      and revision>greatest(p_since,coalesce(p_after,p_since)) and revision<=p_until
      order by revision limit p_limit) c;
  return v_rows;
end $$;
revoke all on function public.offline_pull_changes(bigint,bigint,bigint,int) from public,anon;
grant execute on function public.offline_pull_changes(bigint,bigint,bigint,int) to authenticated;
commit;
