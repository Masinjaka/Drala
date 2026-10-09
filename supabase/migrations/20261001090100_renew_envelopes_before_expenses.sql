begin;

-- Renew before both manual expense routing and the AI wallet preflight.
alter function public.route_expense_funds(uuid, uuid, boolean)
  rename to route_expense_funds_before_monthly;
create function public.route_expense_funds(
  p_transaction_id uuid, p_wallet_id uuid, p_use_all_wallets boolean
) returns void language plpgsql security definer set search_path = '' as $$
declare
  v_tx public."transaction"%rowtype;
begin
  select * into v_tx from public."transaction" where id = p_transaction_id;
  if v_tx.transaction_type = 'expense' then
    perform public.renew_monthly_envelopes_for_user(v_tx.user_id, v_tx.ledger_month);
  end if;
  perform public.route_expense_funds_before_monthly(
    p_transaction_id, p_wallet_id, p_use_all_wallets
  );
end;
$$;
revoke all on function public.route_expense_funds(uuid, uuid, boolean)
  from public, anon, authenticated;

alter function public.complete_finance_request(
  uuid, uuid, jsonb, jsonb, jsonb, jsonb, integer, integer, uuid, date, boolean
) rename to complete_finance_request_before_monthly;
create function public.complete_finance_request(
  p_request_id uuid, p_user_id uuid, p_provider_response jsonb,
  p_transactions jsonb, p_transfers jsonb default '[]',
  p_categories jsonb default '[]', p_input_tokens integer default null,
  p_output_tokens integer default null, p_expense_wallet_id uuid default null,
  p_period_month date default current_date, p_use_all_wallets boolean default false
) returns jsonb language plpgsql security definer set search_path = '' as $$
begin
  perform public.renew_monthly_envelopes_for_user(p_user_id, p_period_month);
  return public.complete_finance_request_before_monthly(
    p_request_id, p_user_id, p_provider_response, p_transactions, p_transfers,
    p_categories, p_input_tokens, p_output_tokens, p_expense_wallet_id,
    p_period_month, p_use_all_wallets
  );
end;
$$;
revoke all on function public.complete_finance_request(
  uuid, uuid, jsonb, jsonb, jsonb, jsonb, integer, integer, uuid, date, boolean
) from public, anon, authenticated;
grant execute on function public.complete_finance_request(
  uuid, uuid, jsonb, jsonb, jsonb, jsonb, integer, integer, uuid, date, boolean
) to service_role;

commit;
