import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_snapshot.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('snapshot exports only the completed guest profile and its records',
      () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.customInsert(
      '''INSERT INTO guest_profiles
         (id,currency_code,language_code,theme_mode,onboarding_complete,created_at)
         VALUES('guest','MGA','fr','dark',0,'2026-01-01T00:00:00Z')''',
    );
    final exporter = GuestSnapshot(database, 'guest');
    await expectLater(exporter.export(), throwsStateError);
    await database.customUpdate(
      "UPDATE guest_profiles SET onboarding_complete=1 WHERE id='guest'",
    );
    final wallet = await GuestWalletStore(database, 'guest').add(
      const AddWalletInput(name: 'Cash', initialBalance: 200),
    );
    await database.customInsert(
      '''INSERT INTO guest_wallet_debits
         (transaction_id,wallet_id,user_id,amount) VALUES(?,?,?,?)''',
      variables: [
        Variable.withString('expense'),
        Variable.withString(wallet.id),
        Variable.withString('guest'),
        Variable.withInt(100),
      ],
    );
    final snapshot = await exporter.export();
    expect((snapshot['profile'] as Map)['language_code'], 'fr');
    expect((snapshot['profile'] as Map)['theme_mode'], 'dark');
    expect((snapshot['wallets'] as List).single['id'], wallet.id);
    expect(snapshot['categories'], isEmpty);
    expect(snapshot['transactions'], isEmpty);
    expect((snapshot['wallet_debits'] as List).single['amount'], 100);
  });
}
