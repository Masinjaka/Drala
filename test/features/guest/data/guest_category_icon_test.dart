import 'dart:convert';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/guest/data/guest_category_store.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:flutter_test/flutter_test.dart';
import '../support/guest_finance_fixture.dart';

void main() {
  test('category icons persist in pickers, envelopes, and the sync journal',
      () async {
    final fixture = await GuestFinanceFixture.open();
    addTearDown(fixture.database.close);
    final store = GuestCategoryStore(fixture.database, 'guest');
    final id = await store.add(Category(
        name: 'Internet',
        iconKey: 'internet',
        emoji: '',
        transactionType: TransactionType.expense));
    final saved = (await store.categories()).singleWhere((c) => c.id == id);
    expect(saved.iconKey, 'internet');
    expect(saved.emoji, isEmpty);
    final pickers =
        await GuestEntryQueries(fixture.database, 'guest').categories();
    expect(pickers.singleWhere((c) => c.id == id).iconKey, 'internet');
    final repository = fixture.repositories.envelopeRepository;
    await repository.addEnvelope(
        name: 'Internet',
        categoryId: id,
        amount: 100,
        month: DateTime(2026, 10),
        walletId: fixture.wallets.first.id);
    expect(
        (await repository.expenseCategories())
            .singleWhere((c) => c.id == id)
            .iconKey,
        'internet');
    expect(
        (await repository.envelopesForMonth(DateTime(2026, 10))).single.iconKey,
        'internet');
    await store.update(saved.copyWith(iconKey: 'phone'));
    expect((await store.categories()).singleWhere((c) => c.id == id).iconKey,
        'phone');
    expect(
        (await repository.envelopesForMonth(DateTime(2026, 10))).single.iconKey,
        'phone');
    final journal = await fixture.database
        .customSelect(
            "SELECT payload FROM guest_sync_records WHERE table_name='categories' ORDER BY created_at")
        .get();
    expect(
        journal
            .map((row) => jsonDecode(row.read<String>('payload'))['icon_key']),
        ['internet', 'phone']);
  });
}
