do $$
begin
  assert (select balance = 800 from public.wallets
    where id = '10000000-0000-0000-0000-000000000003'),
    'concurrent renewals must debit once';
  assert (select count(*) = 2 from public.envelopes
    where name = 'Concurrent'), 'concurrent renewals must create one new month';
end;
$$;
