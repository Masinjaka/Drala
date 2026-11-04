const guestNotificationSchema = <String>[
  '''CREATE TABLE guest_notifications (
    id TEXT PRIMARY KEY, user_id TEXT NOT NULL, envelope_id TEXT NOT NULL,
    transaction_id TEXT NOT NULL, notification_type TEXT NOT NULL,
    envelope_name TEXT NOT NULL, amount INTEGER NOT NULL, period_month TEXT NOT NULL,
    is_read INTEGER NOT NULL DEFAULT 0, delivered INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    UNIQUE(user_id, transaction_id, notification_type)
  )''',
  'CREATE INDEX guest_notifications_user_date_idx ON guest_notifications(user_id,created_at)',
];
