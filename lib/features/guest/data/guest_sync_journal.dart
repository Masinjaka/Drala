import 'dart:convert';

import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestSyncJournal {
  const GuestSyncJournal(this.database);

  final GuestDatabase database;

  Future<void> record(
    String table,
    String recordId,
    String operation,
    Map<String, Object?> payload,
  ) async {
    await database.customInsert(
      '''INSERT INTO guest_sync_records
         (id, table_name, record_id, operation, payload, created_at)
         VALUES (?, ?, ?, ?, ?, ?)''',
      variables: [
        Variable.withString(const Uuid().v4()),
        Variable.withString(table),
        Variable.withString(recordId),
        Variable.withString(operation),
        Variable.withString(jsonEncode(payload)),
        Variable.withString(DateTime.now().toUtc().toIso8601String()),
      ],
    );
  }
}
