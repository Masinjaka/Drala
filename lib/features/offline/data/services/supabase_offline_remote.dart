import 'package:budgets/features/offline/domain/repositories/offline_remote.dart';
import 'package:budgets/features/offline/domain/models/pending_sync_batch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseOfflineRemote implements OfflineRemote {
  const SupabaseOfflineRemote(this.client, this.accountId);
  final SupabaseClient client;
  @override
  final String accountId;
  void _checkAccount() {
    if (client.auth.currentUser?.id != accountId) {
      throw const AuthException('account_changed');
    }
  }

  Future<dynamic> _rpc(String name, Map<String, dynamic> params) async {
    _checkAccount();
    final result = await client
        .rpc(name, params: params)
        .timeout(const Duration(seconds: 15));
    _checkAccount();
    return result;
  }

  @override
  Future<int> revision() async =>
      int.parse('${await _rpc('offline_sync_revision', {})}');
  @override
  Future<List<Map<String, dynamic>>> changes(
          int since, int until, int? after) async =>
      (await _rpc('offline_pull_changes', {
        'p_since': since,
        'p_until': until,
        'p_after': after,
        'p_limit': 250
      }) as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
  @override
  Future<int> push(PendingSyncBatch batch) async =>
      int.parse('${await _rpc('apply_offline_batch', {
            'p_batch_id': batch.id,
            'p_revision': batch.revision,
            'p_operations': batch.operations
          })}');
  @override
  Future<List<Map<String, dynamic>>> page(String table, String? after) async =>
      (await _rpc('offline_pull_page',
              {'p_table': table, 'p_after': after, 'p_limit': 250}) as List)
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList();
}
