import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_entry_mutations.dart';
import 'package:budgets/features/guest/data/guest_envelope_mutations.dart';
import 'package:budgets/features/guest/data/guest_envelope_queries.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an expense consumes the envelope before its funding wallet', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final now = DateTime.now().toUtc().toIso8601String();
    await database.customInsert(
      '''INSERT INTO guest_profiles
         (id,currency_code,language_code,theme_mode,onboarding_complete,created_at)
         VALUES(?,?,?,?,?,?)''',
      variables: [
        Variable.withString('guest'),
        Variable.withString('MGA'),
        Variable.withString('en'),
        Variable.withString('system'),
        Variable.withInt(1),
        Variable.withString(now),
      ],
    );
    await database.customInsert(
      '''INSERT INTO guest_categories
         (id,user_id,name,transaction_type,emoji,icon_key,created_at,updated_at)
         VALUES(?,?,?,?,?,?,?,?)''',
      variables: [
        Variable.withString('food'),
        Variable.withString('guest'),
        Variable.withString('Food'),
        Variable.withString('expense'),
        Variable.withString('🍔'),
        Variable.withString('food'),
        Variable.withString(now),
        Variable.withString(now),
      ],
    );
    final wallets = GuestWalletStore(database, 'guest');
    final wallet = await wallets.add(const AddWalletInput(
      name: 'Cash',
      initialBalance: 10000,
    ));
    final envelopes = GuestEnvelopeMutations(database, 'guest');
    final queries = GuestEnvelopeQueries(database, 'guest');
    final day = DateTime(2026, 10, 13);
    await envelopes.add(
      name: 'Food',
      categoryId: 'food',
      amount: 7000,
      month: day,
      walletId: wallet.id,
    );
    expect((await wallets.wallets()).single.balance, 3000);

    final entries = GuestEntryMutations(database, 'guest');
    final first = await entries.add(ManualEntryInput(
      title: 'Lunch',
      amount: 5000,
      transactionType: 'expense',
      occurredAt: day,
      categoryId: 'food',
      sourceWalletId: wallet.id,
    ));
    expect((await wallets.wallets()).single.balance, 3000);
    expect((await queries.envelopesForMonth(day)).single.remaining, 2000);

    await entries.update(
        first.id,
        ManualEntryInput(
          title: 'Lunch',
          amount: 8000,
          transactionType: 'expense',
          occurredAt: day,
          categoryId: 'food',
          sourceWalletId: wallet.id,
        ));
    expect((await wallets.wallets()).single.balance, 2000);
    expect((await queries.envelopesForMonth(day)).single.remaining, -1000);
    expect((await queries.envelopesForMonth(day)).single.overspentAmount, 1000);

    await entries.delete(first.id);
    expect((await wallets.wallets()).single.balance, 3000);
    expect((await queries.envelopesForMonth(day)).single.remaining, 7000);
    expect((await queries.envelopesForMonth(day)).single.overspentAmount, 0);
  });
}
