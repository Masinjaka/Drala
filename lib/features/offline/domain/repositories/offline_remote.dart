import 'package:budgets/features/offline/domain/models/pending_sync_batch.dart';

abstract interface class OfflineRemote {
  String get accountId;
  Future<int> revision();
  Future<List<Map<String, dynamic>>> changes(int since, int until, int? after);
  Future<int> push(PendingSyncBatch batch);
  Future<List<Map<String, dynamic>>> page(String table, String? after);
}
