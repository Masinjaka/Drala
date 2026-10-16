import 'package:budgets/features/guest/data/guest_ai_entry_repository.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_entry_mutations.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guest AI requires an account while manual finance stays available',
      () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = GuestAiEntryRepository(
      GuestEntryQueries(database, 'guest'),
      GuestEntryMutations(database, 'guest'),
      GuestWalletStore(database, 'guest'),
    );

    expect((await repository.aiQuota()).remaining, 0);
    await expectLater(
      repository.processMessage('Lunch 100 MGA', targetDate: DateTime.now()),
      throwsStateError,
    );
    expect(await repository.manualEntryCategories(), isEmpty);
  });
}
