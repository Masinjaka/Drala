begin;
create table public.offline_account_revisions (
  user_id uuid primary key references auth.users(id) on delete cascade,
  revision bigint not null default 0
);
create table public.offline_batch_receipts (
  user_id uuid not null references auth.users(id) on delete cascade,
  batch_id uuid not null, operations jsonb not null, revision bigint not null,
  created_at timestamptz not null default now(), primary key(user_id,batch_id)
);
create table public.offline_entity_aliases (
  user_id uuid not null references auth.users(id) on delete cascade,
  table_name text not null, local_id uuid not null, remote_id uuid not null,
  primary key(user_id,table_name,local_id), unique(user_id,table_name,remote_id)
);
create table public.offline_changes (
  user_id uuid not null references auth.users(id) on delete cascade,
  table_name text not null, record_key text not null, revision bigint not null,
  deleted boolean not null, payload jsonb not null,
  primary key(user_id,table_name,record_key)
);
create index offline_changes_revision_idx on public.offline_changes(user_id,revision);
alter table public.offline_changes enable row level security;
revoke all on public.offline_changes from public,anon,authenticated;
alter table public.offline_account_revisions enable row level security;
alter table public.offline_batch_receipts enable row level security;
alter table public.offline_entity_aliases enable row level security;
revoke all on public.offline_account_revisions, public.offline_batch_receipts,
  public.offline_entity_aliases from public,anon,authenticated;
create function public.offline_bump_revision() returns trigger
language plpgsql security definer set search_path='' as $$
declare v_user uuid; v_revision bigint; v_payload jsonb; v_key text;
begin
  if tg_table_schema='auth' then v_user := coalesce(new.id,old.id);
  elsif tg_op='DELETE' then v_user := old.user_id;
  else v_user := new.user_id; end if;
  if not exists(select 1 from auth.users where id=v_user) then return null; end if;
  insert into public.offline_account_revisions(user_id,revision) values(v_user,1)
    on conflict(user_id) do update set revision=public.offline_account_revisions.revision+1
    returning revision into v_revision;
  if tg_table_schema='public' then
    v_payload:=case when tg_op='DELETE' then to_jsonb(old) else to_jsonb(new) end;
    v_key:=case when tg_table_name='transaction_wallet_debits'
      then (v_payload->>'transaction_id') || ':' || (v_payload->>'wallet_id')
      when tg_table_name in ('user','notification_settings') then v_user::text
      else v_payload->>'id' end;
    insert into public.offline_changes values(v_user,tg_table_name,v_key,v_revision,tg_op='DELETE',v_payload)
      on conflict(user_id,table_name,record_key) do update set revision=excluded.revision,
        deleted=excluded.deleted,payload=excluded.payload;
  end if;
  return null;
end $$;
do $$ declare v_table text; begin
  foreach v_table in array array['wallets','categories','envelopes','transaction',
    'transaction_wallet_debits','wallet_transfers','finance_notifications',
    'notification_settings','user'] loop
    execute format('create trigger offline_revision after insert or update or delete on public.%I
      for each row execute function public.offline_bump_revision()',v_table);
  end loop;
end $$;
create trigger offline_metadata_revision after update of raw_user_meta_data on auth.users
  for each row when (old.raw_user_meta_data is distinct from new.raw_user_meta_data)
  execute function public.offline_bump_revision();
create function public.offline_sync_revision() returns bigint
language plpgsql security definer set search_path='' as $$
declare v_user uuid := auth.uid(); v_revision bigint;
begin
  if v_user is null then raise exception 'unauthorized'; end if;
  perform public.renew_monthly_envelopes(current_date);
  insert into public.offline_account_revisions(user_id) values(v_user) on conflict do nothing;
  select revision into v_revision from public.offline_account_revisions where user_id=v_user;
  return v_revision;
end $$;
create function public.offline_remote_id(p_table text,p_id uuid) returns uuid
language sql stable security definer set search_path='' as $$
 select coalesce((select remote_id from public.offline_entity_aliases
   where user_id=auth.uid() and table_name=p_table and local_id=p_id),p_id)
$$;
create function public.offline_local_id(p_user uuid,p_table text,p_id uuid) returns uuid
language sql stable security definer set search_path='' as $$
 select coalesce((select local_id from public.offline_entity_aliases
   where user_id=p_user and table_name=p_table and remote_id=p_id),p_id)
$$;
revoke all on function public.offline_bump_revision(),public.offline_remote_id(text,uuid),
  public.offline_local_id(uuid,text,uuid) from public,anon,authenticated;
revoke all on function public.offline_sync_revision() from public,anon;
grant execute on function public.offline_sync_revision() to authenticated;
commit;
