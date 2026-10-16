import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_entry_mutations.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GuestDatabase database;
  late GuestWalletStore wallets;
  late GuestEntryMutations entries;
  late GuestEntryQueries queries;

  setUp(() async {
    database = GuestDatabase(NativeDatabase.memory());
    wallets = GuestWalletStore(database, 'guest');
    entries = GuestEntryMutations(database, 'guest');
    queries = GuestEntryQueries(database, 'guest');
    await database.customInsert(
      '''INSERT INTO guest_profiles
         (id,currency_code,language_code,theme_mode,onboarding_complete,created_at)
         VALUES (?,?,?,?,?,?)''',
      variables: [
        Variable.withString('guest'),
        Variable.withString('MGA'),
        Variable.withString('en'),
        Variable.withString('system'),
        Variable.withInt(1),
        Variable.withString('2026-01-01T00:00:00Z'),
      ],
    );
  });

  tearDown(() async => database.close());

  test('expense can make a guest wallet negative and delete restores balance',
      () async {
    final wallet = await wallets.add(const AddWalletInput(
      name: 'Cash',
      initialBalance: 0,
    ));
    final input = ManualEntryInput(
      title: 'Lunch',
      amount: 5000,
      transactionType: 'expense',
      occurredAt: DateTime(2026, 10, 13),
      sourceWalletId: wallet.id,
    );
    final entry = await entries.add(input);

    expect((await wallets.wallets()).single.balance, -5000);
    expect(
        (await queries.entriesForDate(input.occurredAt)).single.id, entry.id);

    await entries.delete(entry.id);
    expect((await wallets.wallets()).single.balance, 0);
    expect(await queries.entriesForDate(input.occurredAt), isEmpty);
  });

  test('editing an expense reverses its old amount before applying the new one',
      () async {
    final wallet = await wallets.add(const AddWalletInput(
      name: 'Cash',
      initialBalance: 10000,
    ));
    final day = DateTime(2026, 10, 13);
    final original = await entries.add(ManualEntryInput(
      title: 'Lunch',
      amount: 3000,
      transactionType: 'expense',
      occurredAt: day,
      sourceWalletId: wallet.id,
    ));
    await entries.update(
        original.id,
        ManualEntryInput(
          title: 'Lunch',
          amount: 4000,
          transactionType: 'expense',
          occurredAt: day,
          sourceWalletId: wallet.id,
        ));

    expect((await wallets.wallets()).single.balance, 6000);
    expect((await queries.entriesForDate(day)).single.amount, 4000);
    final journal = await database.customSelect(
      'SELECT operation FROM guest_sync_records WHERE table_name = ?',
      variables: [Variable.withString('transaction')],
    ).get();
    expect(journal, hasLength(2));
  });
}
