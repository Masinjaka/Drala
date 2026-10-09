begin;

alter table public.envelopes
  add column repeats_monthly boolean not null default false;
create unique index envelopes_monthly_source_idx
  on public.envelopes(user_id, category_id) where repeats_monthly;

-- Only the current month is materialized. Historical ledgers are never reset
-- or backfilled by opening an old month, and missed months are not charged.
create function public.renew_monthly_envelopes_for_user(
  p_user_id uuid, p_month date
) returns void language plpgsql security definer set search_path = '' as $$
declare
  v_source public.envelopes%rowtype;
  v_wallet public.wallets%rowtype;
  v_month date := date_trunc('month', p_month)::date;
begin
  if p_user_id is null or v_month <> date_trunc('month', current_date)::date then
    return;
  end if;
  perform pg_advisory_xact_lock(hashtextextended(p_user_id::text, 61001));
  for v_source in
    select * from public.envelopes
    where user_id = p_user_id and repeats_monthly and period_month < v_month
    order by funding_wallet_id, id for update
  loop
    if exists (
      select 1 from public.envelopes
      where user_id = p_user_id and category_id = v_source.category_id
        and period_month = v_month
    ) then continue; end if;
    select * into v_wallet from public.wallets
    where id = v_source.funding_wallet_id and user_id = p_user_id for update;
    -- Leave the schedule pending when funding is unavailable; retry on use.
    if v_wallet.id is null or v_wallet.balance < v_source.amount then
      continue;
    end if;
    begin
      update public.envelopes set repeats_monthly = false
      where id = v_source.id;
      insert into public.envelopes(
        user_id, category_id, name, amount, remaining_amount, currency_code,
        period_month, funding_wallet_id, repeats_monthly
      ) values (
        p_user_id, v_source.category_id, v_source.name, v_source.amount,
        v_source.amount, v_source.currency_code, v_month, v_wallet.id, true
      );
      update public.wallets
      set balance = balance - v_source.amount, updated_at = now()
      where id = v_wallet.id;
    exception when unique_violation then
      -- A simultaneous one-off creation won. Its debit and this schedule
      -- remain intact because this subtransaction is rolled back.
      null;
    end;
  end loop;
end;
$$;

create function public.renew_monthly_envelopes(p_month date default current_date)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if auth.uid() is null then raise exception 'unauthorized'; end if;
  perform public.renew_monthly_envelopes_for_user(auth.uid(), p_month);
end;
$$;

create function public.fund_monthly_envelope(
  p_name text, p_category_id uuid, p_amount bigint, p_period_month date,
  p_wallet_id uuid default null
) returns jsonb language plpgsql security definer set search_path = '' as $$
declare
  v_result jsonb;
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then raise exception 'unauthorized'; end if;
  perform pg_advisory_xact_lock(hashtextextended(v_user_id::text, 61001));
  v_result := public.fund_envelope(
    p_name, p_category_id, p_amount, p_period_month, p_wallet_id
  );
  update public.envelopes set repeats_monthly = false
  where user_id = v_user_id and category_id = p_category_id and repeats_monthly;
  update public.envelopes set repeats_monthly = true
  where id = (v_result->>'id')::uuid and user_id = v_user_id;
  return v_result || jsonb_build_object('repeats_monthly', true);
end;
$$;

revoke all on function public.renew_monthly_envelopes_for_user(uuid, date)
  from public, anon, authenticated;
revoke all on function public.renew_monthly_envelopes(date) from public, anon;
grant execute on function public.renew_monthly_envelopes(date) to authenticated;
revoke all on function public.fund_monthly_envelope(text, uuid, bigint, date, uuid)
  from public, anon;
grant execute on function public.fund_monthly_envelope(text, uuid, bigint, date, uuid)
  to authenticated;

commit;
