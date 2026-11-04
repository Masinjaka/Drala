const offlineSchema = <String>[
  '''CREATE TABLE offline_state (key TEXT PRIMARY KEY, value TEXT NOT NULL)''',
  '''CREATE TABLE offline_staging (
    table_name TEXT NOT NULL, record_id TEXT NOT NULL, payload TEXT NOT NULL,
    PRIMARY KEY(table_name, record_id))''',
];
