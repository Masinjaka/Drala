import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/core/offline/legacy_image_data_cleanup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountDataService {
  const AccountDataService(this._client, {this.offline});
  final OfflineAccount? offline;

  final SupabaseClient _client;

  String get accountConfirmation => _client.auth.currentUser?.email ?? '';

  Future<void> deleteAllData(String confirmation) =>
      _invoke(action: 'data', confirmation: confirmation);

  Future<void> deleteAccount(String confirmation) async {
    await _invoke(action: 'account', confirmation: confirmation);
    await _client.auth.signOut(scope: SignOutScope.local);
  }

  Future<void> _invoke({
    required String action,
    required String confirmation,
  }) async {
    if (_client.auth.currentSession == null) {
      throw StateError('No authenticated session');
    }
    await offline?.synchronize();
    offline?.requireOnline();
    offline?.setActive(false);
    try {
      await deleteLegacyImageData();
      await _client.functions.invoke(
        'delete-user-data',
        body: {'action': action, 'confirmation': confirmation},
      );
      await offline?.resetAfterCloudDeletion();
    } on FunctionException catch (error) {
      throw Exception(_messageFrom(error.details));
    } finally {
      offline?.setActive(true);
    }
  }

  String _messageFrom(Object? details) {
    if (details is! Map) return 'Deletion failed';
    final error = details['error'];
    if (error is Map && error['message'] is String) {
      return error['message'] as String;
    }
    return 'Deletion failed';
  }
}
