import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_entry_mutations.dart';
import 'package:budgets/features/guest/data/guest_envelope_mutations.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deleting a spent envelope preserves both wallet debits', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.now().toUtc().toIso8601String();
    await database.customInsert(
      '''INSERT INTO guest_categories
         (id,user_id,name,transaction_type,created_at,updated_at)
         VALUES('food','guest','Food','expense',?,?)''',
      variables: [Variable.withString(now), Variable.withString(now)],
    );
    final wallets = GuestWalletStore(database, 'guest');
    final funding = await wallets.add(
      const AddWalletInput(name: 'Cash', initialBalance: 10000),
    );
    final extra = await wallets.add(
      const AddWalletInput(name: 'Bank', initialBalance: 1000),
    );
    final month = DateTime(2026, 10, 13);
    final envelopes = GuestEnvelopeMutations(database, 'guest');
    await envelopes.add(
      name: 'Food',
      categoryId: 'food',
      amount: 7000,
      month: month,
      walletId: funding.id,
    );
    final entries = GuestEntryMutations(database, 'guest');
    final entry = await entries.add(ManualEntryInput(
      title: 'Lunch',
      amount: 8000,
      transactionType: 'expense',
      occurredAt: month,
      categoryId: 'food',
      sourceWalletId: extra.id,
    ));
    final envelope = await database.customSelect(
      'SELECT id FROM guest_envelopes WHERE user_id=?',
      variables: [Variable.withString('guest')],
    ).getSingle();
    await envelopes.delete(envelope.read<String>('id'));

    final transaction = await database.customSelect(
      'SELECT envelope_id,envelope_amount_used FROM guest_transactions WHERE id=?',
      variables: [Variable.withString(entry.id)],
    ).getSingle();
    expect(transaction.read<String?>('envelope_id'), isNull);
    expect(transaction.read<int>('envelope_amount_used'), 0);
    final debits = await database.customSelect(
      'SELECT wallet_id,amount FROM guest_wallet_debits WHERE transaction_id=?',
      variables: [Variable.withString(entry.id)],
    ).get();
    expect({
      for (final row in debits)
        row.read<String>('wallet_id'): row.read<int>('amount')
    }, {
      funding.id: 7000,
      extra.id: 1000
    });

    await entries.delete(entry.id);
    final balances = {
      for (final wallet in await wallets.wallets()) wallet.id: wallet.balance
    };
    expect(balances, {funding.id: 10000, extra.id: 1000});
  });
}
