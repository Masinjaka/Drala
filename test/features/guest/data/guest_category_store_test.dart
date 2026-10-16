import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/guest/data/guest_category_store.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('category edits persist; deleting an unused category is journaled', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final store = GuestCategoryStore(database, 'guest');
    final id = await store.add(Category(
      name: 'Food',
      emoji: '🍔',
      color: 'FFFF9800',
      transactionType: TransactionType.expense,
    ));
    expect((await store.categories()).single.name, 'Food');
    await store.update(Category(
      id: id,
      name: 'Groceries',
      emoji: '🛒',
      color: 'FFFF9800',
      transactionType: TransactionType.expense,
    ));
    expect((await store.categories()).single.name, 'Groceries');
    await store.delete(Category(id: id));
    expect(await store.categories(), isEmpty);
    final journal = await database.customSelect(
      'SELECT operation FROM guest_sync_records ORDER BY created_at',
    ).get();
    expect(journal.map((row) => row.read<String>('operation')),
        containsAll(['upsert', 'delete']));
  });
}
