begin;

create table public.guest_ai_usage (
  usage_day date not null,
  source_key text not null,
  request_count integer not null default 0,
  last_request_at timestamptz not null default now(),
  primary key (usage_day, source_key)
);
alter table public.guest_ai_usage enable row level security;
revoke all on public.guest_ai_usage from public, anon, authenticated;

create or replace function public.reserve_guest_ai_request(
  p_ip_hash text, p_guest_id uuid
) returns integer
language plpgsql security definer set search_path = ''
as $$
declare
  v_day date := (now() at time zone 'utc')::date;
  v_count integer;
begin
  if p_ip_hash !~ '^[0-9a-f]{64}$' or p_guest_id is null then
    raise exception 'invalid_guest_ai_source';
  end if;
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_day::text, 15092026)
  );
  insert into public.guest_ai_usage(usage_day,source_key,request_count)
  values(v_day,'global',1)
  on conflict(usage_day,source_key) do update
    set request_count=public.guest_ai_usage.request_count+1,
        last_request_at=now()
    where public.guest_ai_usage.request_count < 1000;
  if not found then raise exception 'guest_ai_global_limit'; end if;
  insert into public.guest_ai_usage(usage_day,source_key,request_count)
  values(v_day,'ip:' || p_ip_hash,1)
  on conflict(usage_day,source_key) do update
    set request_count=public.guest_ai_usage.request_count+1,
        last_request_at=now()
    where public.guest_ai_usage.request_count < 100;
  if not found then raise exception 'guest_ai_ip_limit'; end if;
  insert into public.guest_ai_usage(usage_day,source_key,request_count)
  values(v_day,'guest:' || p_guest_id::text,1)
  on conflict(usage_day,source_key) do update
    set request_count=public.guest_ai_usage.request_count+1,
        last_request_at=now()
    where public.guest_ai_usage.request_count < 20
      and public.guest_ai_usage.last_request_at <= now() - interval '3 seconds'
  returning request_count into v_count;
  if v_count is null then raise exception 'guest_ai_rate_limited'; end if;
  return 20 - v_count;
end;
$$;
revoke all on function public.reserve_guest_ai_request(text,uuid)
  from public, anon, authenticated;
grant execute on function public.reserve_guest_ai_request(text,uuid)
  to service_role;

commit;
