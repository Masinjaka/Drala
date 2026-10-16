const guestSchema = <String>[
  '''CREATE TABLE guest_profiles (
    id TEXT PRIMARY KEY, currency_code TEXT NOT NULL DEFAULT 'MGA',
    language_code TEXT NOT NULL DEFAULT 'en',
    theme_mode TEXT NOT NULL DEFAULT 'system',
    onboarding_complete INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
  )''',
  '''CREATE TABLE guest_wallets (
    id TEXT PRIMARY KEY, user_id TEXT NOT NULL, name TEXT NOT NULL,
    balance INTEGER NOT NULL DEFAULT 0, currency_code TEXT NOT NULL DEFAULT 'MGA',
    icon_key TEXT NOT NULL DEFAULT 'wallet', is_default INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL, updated_at TEXT NOT NULL
  )''',
  '''CREATE TABLE guest_categories (
    id TEXT PRIMARY KEY, user_id TEXT NOT NULL, name TEXT NOT NULL,
    transaction_type TEXT NOT NULL, emoji TEXT NOT NULL DEFAULT '🧾',
    color TEXT, icon_key TEXT NOT NULL DEFAULT 'other',
    created_at TEXT NOT NULL, updated_at TEXT NOT NULL
  )''',
  '''CREATE TABLE guest_transactions (
    id TEXT PRIMARY KEY, user_id TEXT NOT NULL, title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '', amount INTEGER NOT NULL,
    transaction_type TEXT NOT NULL, entry_type TEXT NOT NULL DEFAULT 'transaction',
    date TEXT NOT NULL, currency_code TEXT NOT NULL DEFAULT 'MGA',
    category_id TEXT, source_wallet_id TEXT, envelope_id TEXT,
    envelope_amount_used INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL, updated_at TEXT NOT NULL
  )''',
  '''CREATE TABLE guest_envelopes (
    id TEXT PRIMARY KEY, user_id TEXT NOT NULL, category_id TEXT NOT NULL,
    name TEXT NOT NULL, amount INTEGER NOT NULL,
    remaining_amount INTEGER NOT NULL, overspent_amount INTEGER NOT NULL DEFAULT 0,
    period_month TEXT NOT NULL,
    funding_wallet_id TEXT NOT NULL,
    currency_code TEXT NOT NULL DEFAULT 'MGA',
    repeats_monthly INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL, updated_at TEXT NOT NULL,
    UNIQUE(user_id, category_id, period_month)
  )''',
  '''CREATE TABLE guest_wallet_debits (
    transaction_id TEXT NOT NULL, wallet_id TEXT NOT NULL,
    user_id TEXT NOT NULL, amount INTEGER NOT NULL,
    PRIMARY KEY(transaction_id, wallet_id)
  )''',
  '''CREATE TABLE guest_wallet_transfers (
    id TEXT PRIMARY KEY, user_id TEXT NOT NULL,
    from_wallet_id TEXT NOT NULL, to_wallet_id TEXT NOT NULL,
    amount INTEGER NOT NULL, currency_code TEXT NOT NULL DEFAULT 'MGA',
    description TEXT NOT NULL DEFAULT '', occurred_at TEXT NOT NULL,
    created_at TEXT NOT NULL
  )''',
  '''CREATE TABLE guest_preferences (
    key TEXT PRIMARY KEY, value TEXT NOT NULL, updated_at TEXT NOT NULL
  )''',
  '''CREATE TABLE guest_sync_records (
    id TEXT PRIMARY KEY, table_name TEXT NOT NULL, record_id TEXT NOT NULL,
    operation TEXT NOT NULL, payload TEXT NOT NULL, created_at TEXT NOT NULL
  )''',
  'CREATE INDEX guest_transactions_date_idx ON guest_transactions(date)',
  'CREATE INDEX guest_transactions_category_idx ON guest_transactions(category_id)',
  'CREATE INDEX guest_wallet_debits_wallet_idx ON guest_wallet_debits(wallet_id)',
  'CREATE INDEX guest_wallet_transfers_date_idx ON guest_wallet_transfers(occurred_at)',
  'CREATE INDEX guest_sync_records_created_idx ON guest_sync_records(created_at)',
];
