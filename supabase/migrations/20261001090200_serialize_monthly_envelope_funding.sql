begin;

-- Take the same per-user lock BEFORE existing routines acquire wallet or
-- envelope row locks. Keep the original accounting routines unchanged.
create function public.lock_envelope_funding()
returns void language plpgsql security definer set search_path = '' as $$
begin
  if auth.uid() is null then raise exception 'unauthorized'; end if;
  perform pg_advisory_xact_lock(hashtextextended(auth.uid()::text, 61001));
end;
$$;
revoke all on function public.lock_envelope_funding()
  from public, anon, authenticated;

alter function public.create_manual_finance_entry(
  text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
) rename to create_manual_finance_entry_before_monthly;
create function public.create_manual_finance_entry(
  p_title text, p_description text, p_amount bigint, p_occurred_at timestamptz,
  p_transaction_type text, p_category_id uuid default null,
  p_source_wallet_id uuid default null, p_period_month date default current_date,
  p_use_all_wallets boolean default false
) returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  perform public.lock_envelope_funding();
  return public.create_manual_finance_entry_before_monthly(
    p_title, p_description, p_amount, p_occurred_at, p_transaction_type,
    p_category_id, p_source_wallet_id, p_period_month, p_use_all_wallets
  );
end;
$$;

alter function public.update_finance_entry(
  uuid, text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
) rename to update_finance_entry_before_monthly;
create function public.update_finance_entry(
  p_transaction_id uuid, p_title text, p_description text, p_amount bigint,
  p_occurred_at timestamptz, p_transaction_type text,
  p_category_id uuid default null, p_source_wallet_id uuid default null,
  p_period_month date default current_date, p_use_all_wallets boolean default false
) returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  perform public.lock_envelope_funding();
  return public.update_finance_entry_before_monthly(
    p_transaction_id, p_title, p_description, p_amount, p_occurred_at,
    p_transaction_type, p_category_id, p_source_wallet_id, p_period_month,
    p_use_all_wallets
  );
end;
$$;

alter function public.delete_finance_entry(uuid)
  rename to delete_finance_entry_before_monthly;
create function public.delete_finance_entry(p_transaction_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
begin
  perform public.lock_envelope_funding();
  perform public.delete_finance_entry_before_monthly(p_transaction_id);
end;
$$;

alter function public.delete_funded_envelope(uuid)
  rename to delete_funded_envelope_before_monthly;
create function public.delete_funded_envelope(p_envelope_id uuid)
returns void language plpgsql security definer set search_path = '' as $$
begin
  perform public.lock_envelope_funding();
  perform public.delete_funded_envelope_before_monthly(p_envelope_id);
end;
$$;

alter function public.fund_envelope(text, uuid, bigint, date, uuid)
  rename to fund_envelope_before_monthly;
create function public.fund_envelope(
  p_name text, p_category_id uuid, p_amount bigint, p_period_month date,
  p_wallet_id uuid default null
) returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  perform public.lock_envelope_funding();
  return public.fund_envelope_before_monthly(
    p_name, p_category_id, p_amount, p_period_month, p_wallet_id
  );
end;
$$;

revoke all on function public.create_manual_finance_entry_before_monthly(
  text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
), public.update_finance_entry_before_monthly(
  uuid, text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
), public.delete_finance_entry_before_monthly(uuid),
public.delete_funded_envelope_before_monthly(uuid),
public.fund_envelope_before_monthly(text, uuid, bigint, date, uuid)
from public, anon, authenticated;

revoke all on function public.create_manual_finance_entry(
  text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
), public.update_finance_entry(
  uuid, text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
), public.delete_finance_entry(uuid), public.delete_funded_envelope(uuid),
public.fund_envelope(text, uuid, bigint, date, uuid)
from public, anon;

grant execute on function public.create_manual_finance_entry(
  text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
), public.update_finance_entry(
  uuid, text, text, bigint, timestamptz, text, uuid, uuid, date, boolean
), public.delete_finance_entry(uuid), public.delete_funded_envelope(uuid),
public.fund_envelope(text, uuid, bigint, date, uuid)
to authenticated;

commit;
