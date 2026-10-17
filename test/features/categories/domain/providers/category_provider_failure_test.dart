import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:budgets/features/guest/data/guest_category_store.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('a failed category deletion leaves the existing list visible', () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final session = await GuestSession.load(database);
    await session.start();
    final store = GuestCategoryStore(database, session.userId);
    final categoryId = await store.add(Category(
      name: 'Food',
      emoji: '🍔',
      color: 'FFFF9800',
      transactionType: TransactionType.expense,
    ));
    final date = DateTime.utc(2026, 10, 16).toIso8601String();
    await database.customStatement(
      '''INSERT INTO guest_transactions
         (id,user_id,title,amount,transaction_type,date,category_id,created_at,updated_at)
         VALUES (?,?,?,?,?,?,?,?,?)''',
      [
        'entry',
        session.userId,
        'Lunch',
        100,
        'expense',
        date,
        categoryId,
        date,
        date
      ],
    );
    final container = ProviderContainer(overrides: [
      guestSessionProvider.overrideWithValue(session),
    ]);
    addTearDown(container.dispose);
    expect(
        (await container.read(categoriesProvider.future)).single.name, 'Food');

    await expectLater(
      container
          .read(categoriesProvider.notifier)
          .deleteSomeCategory(Category(id: categoryId)),
      throwsA(isA<StateError>().having(
        (error) => error.message,
        'message',
        'Category is in use.',
      )),
    );

    final state = container.read(categoriesProvider);
    expect(state.hasError, isFalse);
    expect(state.value!.single.name, 'Food');
  });
}
