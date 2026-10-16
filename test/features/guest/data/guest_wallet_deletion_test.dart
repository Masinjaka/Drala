import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_transfer_store.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/errors/wallet_deletion_exception.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wallet funding an envelope cannot be deleted', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final wallets = GuestWalletStore(database, 'guest');
    final wallet = await wallets.add(
      const AddWalletInput(name: 'Cash', initialBalance: 10000),
    );
    final now = DateTime.now().toUtc().toIso8601String();
    await database.customInsert(
      '''INSERT INTO guest_envelopes
         (id,user_id,category_id,name,amount,remaining_amount,period_month,
          funding_wallet_id,created_at,updated_at)
         VALUES(?,?,?,?,?,?,?,?,?,?)''',
      variables: [
        Variable.withString('envelope'),
        Variable.withString('guest'),
        Variable.withString('food'),
        Variable.withString('Food'),
        Variable.withInt(5000),
        Variable.withInt(5000),
        Variable.withString('2026-10-01'),
        Variable.withString(wallet.id),
        Variable.withString(now),
        Variable.withString(now),
      ],
    );

    expect(
      () => wallets.delete(wallet.id),
      throwsA(isA<WalletDeletionException>()),
    );
    expect((await wallets.wallets()).single.id, wallet.id);
  });

  test('wallet referenced by a transfer cannot be deleted', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final wallets = GuestWalletStore(database, 'guest');
    final cash = await wallets.add(
      const AddWalletInput(name: 'Cash', initialBalance: 1000),
    );
    final bank = await wallets.add(
      const AddWalletInput(name: 'Bank', initialBalance: 0),
    );
    await GuestTransferStore(database, 'guest').add(
      fromWalletId: cash.id,
      toWalletId: bank.id,
      amount: 300,
      occurredAt: DateTime(2026, 10, 15),
    );
    await expectLater(
      wallets.delete(cash.id),
      throwsA(isA<WalletDeletionException>()),
    );
    await expectLater(
      wallets.delete(bank.id),
      throwsA(isA<WalletDeletionException>()),
    );
  });
}
