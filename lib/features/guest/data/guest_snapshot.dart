import 'dart:convert';

import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/drift.dart';

class GuestSnapshot {
  const GuestSnapshot(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<Map<String, Object?>> export() => database.transaction(() async {
        final profile = await database.customSelect(
          '''SELECT currency_code,language_code,theme_mode,onboarding_complete
             FROM guest_profiles WHERE id=?''',
          variables: [Variable.withString(userId)],
        ).getSingle();
        if (profile.read<int>('onboarding_complete') != 1) {
          throw StateError('Guest onboarding is not complete.');
        }
        final preferences = await database.customSelect(
          'SELECT value FROM guest_preferences WHERE key=?',
          variables: [Variable.withString('notifications:$userId')],
        ).get();
        return {
          'profile': profile.data,
          'wallets': await _rows('guest_wallets'),
          'categories': await _rows('guest_categories'),
          'envelopes': await _rows('guest_envelopes'),
          'transactions': await _rows('guest_transactions'),
          'wallet_debits': await _rows('guest_wallet_debits'),
          'wallet_transfers': await _rows('guest_wallet_transfers'),
          if (preferences.isNotEmpty)
            'notifications': jsonDecode(
              preferences.single.read<String>('value'),
            ),
        };
      });

  Future<List<Map<String, dynamic>>> _rows(String table) async {
    const allowed = {
      'guest_wallets',
      'guest_categories',
      'guest_envelopes',
      'guest_transactions',
      'guest_wallet_debits',
      'guest_wallet_transfers',
    };
    if (!allowed.contains(table)) throw ArgumentError.value(table);
    final rows = await database.customSelect(
      'SELECT * FROM $table WHERE user_id=?',
      variables: [Variable.withString(userId)],
    ).get();
    return rows.map((row) => row.data).toList(growable: false);
  }
}
