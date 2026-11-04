import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/user/data/datasources/supabase_user_datasource.dart';
import 'package:budgets/features/user/domain/models/user_model.dart';
import 'package:drift/drift.dart';

class OfflineUserDataSource extends SupabaseUserDataSource {
  OfflineUserDataSource(super.client, this.account);
  final OfflineAccount account;
  @override
  Future<UserModel> getCurrentUserRow() async {
    final rows = await account.database.customSelect(
        'SELECT * FROM guest_profiles WHERE id=?',
        variables: [Variable.withString(account.id)]).get();
    if (rows.isEmpty) return UserModel();
    return UserModel.fromJson(rows.single.data);
  }

  Future<void> _set(String column, String value) =>
      account.database.transaction(() async {
        await account.database.customUpdate(
            'UPDATE guest_profiles SET $column=? WHERE id=?',
            variables: [
              Variable.withString(value),
              Variable.withString(account.id)
            ]);
        await GuestSyncJournal(account.database)
            .record('user', account.id, 'upsert', {column: value});
      });
  @override
  Future<void> updateUsername(String username) => _set('username', username);
  @override
  Future<void> updateCurrencyCode(String currencyCode) =>
      _set('currency_code', currencyCode);
}
