import 'package:budgets/features/offline/data/services/offline_outbox_store.dart';
import 'package:budgets/features/offline/data/services/offline_snapshot_store.dart';
import 'package:budgets/features/offline/domain/repositories/offline_remote.dart';

class OfflineSyncEngine {
  const OfflineSyncEngine(this.remote, this.outbox, this.snapshot);
  final OfflineRemote remote;
  final OfflineOutboxStore outbox;
  final OfflineSnapshotStore snapshot;
  Future<bool> sync() async {
    // Recover a lost acknowledgement before checking cloud revisions or pulling.
    while (true) {
      final batch = await outbox.batch();
      if (batch == null) break;
      await outbox.acknowledge(batch, await remote.push(batch));
    }
    final revision = await remote.revision();
    if (await outbox.state('hydrated') == '1' &&
        await outbox.state('pulled_revision') == '$revision') {
      return false;
    }
    await snapshot.clearStaging();
    final previous = await outbox.state('pulled_revision');
    final delta = previous != null && await outbox.state('hydrated') == '1';
    if (delta) {
      int? cursor;
      while (true) {
        final rows =
            await remote.changes(int.parse(previous), revision, cursor);
        if (rows.isEmpty) break;
        final grouped = <String, List<Map<String, dynamic>>>{};
        for (final change in rows) {
          (grouped[change['table'] as String] ??= [])
              .add(Map<String, dynamic>.from(change['payload'] as Map));
        }
        for (final entry in grouped.entries) {
          await snapshot.stage(entry.key, entry.value);
        }
        final next = (rows.last['revision'] as num).toInt();
        if (next == cursor) throw StateError('offline_cursor_not_advancing');
        cursor = next;
        if (rows.length < 250) break;
      }
    } else {
      for (final table in OfflineSnapshotStore.tables.keys) {
        String? cursor;
        while (true) {
          final rows = await remote.page(table, cursor);
          if (rows.isEmpty) break;
          await snapshot.stage(table, rows);
          final next = rows.last['_key'] as String;
          if (next == cursor) throw StateError('offline_cursor_not_advancing');
          cursor = next;
          if (rows.length < 250) break;
        }
      }
    }
    // Pages must belong to one unchanged server revision. Never publish a
    // partial download, or replace edits made while that download was in flight.
    if (revision != await remote.revision()) {
      throw StateError('offline_snapshot_changed');
    }
    if (!await snapshot.install(revision, delta: delta)) {
      throw StateError('offline_local_edits_pending');
    }
    return true;
  }
}
