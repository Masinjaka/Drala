import 'dart:async';
import 'dart:io';
import 'package:budgets/features/offline/domain/models/pending_sync_batch.dart';
import 'package:budgets/features/offline/domain/repositories/offline_remote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FakeOfflineRemote implements OfflineRemote {
  FakeOfflineRemote(this.accountId);
  @override
  final String accountId;
  int version = 1;
  int commits = 0;
  bool offline = false;
  bool loseAcknowledgement = false;
  bool failChanges = false;
  final tables = <String, List<Map<String, dynamic>>>{};
  final deltas = <Map<String, dynamic>>[];
  final receipts = <String, int>{};
  final batches = <PendingSyncBatch>[];
  Future<void> Function(String table)? beforePage;
  @override
  Future<int> revision() async {
    if (offline) throw const SocketException('offline');
    return version;
  }

  @override
  Future<int> push(PendingSyncBatch batch) async {
    if (offline) throw const SocketException('offline');
    batches.add(batch);
    if (receipts.containsKey(batch.id)) return receipts[batch.id]!;
    if (batch.revision != version) {
      throw const PostgrestException(message: 'offline_sync_conflict');
    }
    commits++;
    receipts[batch.id] = ++version;
    if (loseAcknowledgement) {
      loseAcknowledgement = false;
      throw const SocketException('response lost');
    }
    return version;
  }

  @override
  Future<List<Map<String, dynamic>>> page(String table, String? after) async {
    if (offline) throw const SocketException('offline');
    await beforePage?.call(table);
    final values = [...?tables[table]]
      ..sort((a, b) => (a['_key'] as String).compareTo(b['_key'] as String));
    return values
        .where(
            (r) => after == null || (r['_key'] as String).compareTo(after) > 0)
        .take(250)
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> changes(
      int since, int until, int? after) async {
    if (offline || failChanges) throw const SocketException('offline');
    return deltas
        .where((row) =>
            (row['revision'] as int) > (after ?? since) &&
            (row['revision'] as int) <= until)
        .take(250)
        .toList();
  }
}
