import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('creating a default wallet replaces the previous default', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final store = GuestWalletStore(database, 'guest');
    final first = await store.add(const AddWalletInput(
      name: 'Cash',
      initialBalance: 0,
      setAsDefault: true,
    ));
    final second = await store.add(const AddWalletInput(
      name: 'Savings',
      initialBalance: 0,
      setAsDefault: true,
    ));
    final wallets = await store.wallets();
    expect(first.isDefault, true);
    expect(second.isDefault, true);
    expect(wallets.where((wallet) => wallet.isDefault).single.id, second.id);
  });
}
