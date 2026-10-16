import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('default wallet selection is exclusive and journaled', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final wallets = GuestWalletStore(database, 'guest');
    final cash = await wallets.add(
      const AddWalletInput(name: 'Cash', initialBalance: 0),
    );
    final bank = await wallets.add(
      const AddWalletInput(name: 'Bank', initialBalance: 1000),
    );
    await wallets.setDefault(cash.id);
    await wallets.setDefault(bank.id);
    final current = await wallets.wallets();
    expect(current.where((wallet) => wallet.isDefault).single.id, bank.id);
    final journal = await database
        .customSelect(
          "SELECT * FROM guest_sync_records WHERE operation = 'default'",
        )
        .get();
    expect(journal, hasLength(2));
  });
}
