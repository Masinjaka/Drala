begin;

create or replace function public.get_my_ai_quota(
  p_daily_limit integer default 5
) returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
  v_count integer;
  v_is_pro boolean;
begin
  if v_user_id is null then
    raise exception 'unauthorized';
  end if;

  select exists (
    select 1
    from public.account_plans
    where user_id = v_user_id
      and tier = 'pro'
      and status = 'active'
      and (current_period_end is null or current_period_end > now())
  ) into v_is_pro;

  select count(*)::integer into v_count
  from public.ai_requests
  where user_id = v_user_id
    and created_at >= date_trunc('day', now());

  return jsonb_build_object(
    'plan', case when v_is_pro then 'pro' else 'free' end,
    'unlimited', v_is_pro,
    'remaining', case
      when v_is_pro then null
      else greatest(0, 5 - v_count)
    end
  );
end;
$$;

create or replace function public.reserve_ai_request(
  p_user_id uuid,
  p_provider text,
  p_model text,
  p_prompt text,
  p_daily_limit integer default 5,
  p_min_interval_seconds integer default 3
) returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count integer;
  v_last_created timestamptz;
  v_request_id uuid;
  v_retry_after integer;
  v_is_pro boolean;
begin
  if p_user_id is null or char_length(trim(p_prompt)) not between 1 and 1000 then
    raise exception 'invalid_request';
  end if;

  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(p_user_id::text, 0)
  );

  select exists (
    select 1 from public.account_plans
    where user_id = p_user_id
      and tier = 'pro'
      and status = 'active'
      and (current_period_end is null or current_period_end > now())
  ) into v_is_pro;

  select max(created_at) into v_last_created
  from public.ai_requests where user_id = p_user_id;

  if v_last_created is not null
      and v_last_created > now() - make_interval(secs => p_min_interval_seconds)
  then
    v_retry_after := greatest(1, ceil(extract(epoch from (
      v_last_created + make_interval(secs => p_min_interval_seconds) - now()
    )))::integer);
    return jsonb_build_object(
      'allowed', false,
      'code', 'rate_limited',
      'retry_after_seconds', v_retry_after
    );
  end if;

  select count(*)::integer into v_count
  from public.ai_requests
  where user_id = p_user_id
    and created_at >= date_trunc('day', now());

  if not v_is_pro and v_count >= 5 then
    return jsonb_build_object(
      'allowed', false,
      'code', 'daily_limit_exceeded',
      'remaining', 0,
      'plan', 'free',
      'unlimited', false
    );
  end if;

  insert into public.ai_requests(user_id, provider, model, prompt)
  values (p_user_id, p_provider, p_model, trim(p_prompt))
  returning id into v_request_id;

  insert into public.ai_chat_messages(request_id, user_id, role, content)
  values (v_request_id, p_user_id, 'user', trim(p_prompt));

  return jsonb_build_object(
    'allowed', true,
    'request_id', v_request_id,
    'remaining', case
      when v_is_pro then null
      else 5 - v_count - 1
    end,
    'plan', case when v_is_pro then 'pro' else 'free' end,
    'unlimited', v_is_pro
  );
end;
$$;

commit;
