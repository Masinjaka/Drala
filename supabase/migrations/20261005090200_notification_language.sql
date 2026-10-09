begin;

alter table public.notification_settings
  add column language_code text not null default 'en'
  check (language_code in ('en', 'fr', 'mg', 'de', 'es', 'it'));

commit;
