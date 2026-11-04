import 'dart:convert';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/offline/domain/models/pending_sync_batch.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class OfflineOutboxStore {
  const OfflineOutboxStore(this.database);
  final GuestDatabase database;
  Future<String?> state(String key) async {
    final rows = await database.customSelect(
        'SELECT value FROM offline_state WHERE key=?',
        variables: [Variable.withString(key)]).get();
    return rows.isEmpty ? null : rows.single.read<String>('value');
  }

  Future<void> setState(String key, String value) => database.customStatement(
      'INSERT INTO offline_state(key,value) VALUES(?,?) ON CONFLICT(key) DO UPDATE SET value=excluded.value',
      [key, value]);
  Future<int> count() async => (await database
          .customSelect('SELECT COUNT(*) AS count FROM guest_sync_records')
          .getSingle())
      .read<int>('count');
  Future<PendingSyncBatch?> batch() => database.transaction(() async {
        final existing = await state('batch');
        if (existing != null) {
          return PendingSyncBatch.fromJson(
              jsonDecode(existing) as Map<String, dynamic>);
        }
        final rows = await database
            .customSelect(
                'SELECT * FROM guest_sync_records ORDER BY rowid LIMIT 50')
            .get();
        if (rows.isEmpty) return null;
        final batch = PendingSyncBatch(
            id: const Uuid().v4(),
            revision: int.parse(await state('revision') ?? '0'),
            operations: rows
                .map((row) => {
                      'id': row.read<String>('id'),
                      'table': row.read<String>('table_name'),
                      'record_id': row.read<String>('record_id'),
                      'operation': row.read<String>('operation'),
                      'payload': jsonDecode(row.read<String>('payload')),
                    })
                .toList());
        await setState('batch', jsonEncode(batch.toJson()));
        return batch;
      });
  Future<void> acknowledge(PendingSyncBatch batch, int revision) =>
      database.transaction(() async {
        for (final op in batch.operations) {
          await database.customUpdate(
              'DELETE FROM guest_sync_records WHERE id=?',
              variables: [Variable.withString(op['id'] as String)]);
        }
        await setState('revision', '$revision');
        await database
            .customStatement("DELETE FROM offline_state WHERE key='batch'");
      });
  Future<void> rebase(int revision) => database.transaction(() async {
        final current = await batch();
        await setState('revision', '$revision');
        if (current != null) {
          await setState(
              'batch',
              jsonEncode(PendingSyncBatch(
                      id: current.id,
                      revision: revision,
                      operations: current.operations)
                  .toJson()));
        }
      });
  Future<void> discard() => database.transaction(() async {
        await database.customStatement('DELETE FROM guest_sync_records');
        await database.customStatement(
            "DELETE FROM offline_state WHERE key IN ('batch','hydrated','revision','pulled_revision')");
      });
}
