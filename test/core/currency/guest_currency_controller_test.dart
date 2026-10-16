import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('offline guest currency choice persists without an exchange rate',
      () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    final container = ProviderContainer(overrides: [
      guestSessionProvider.overrideWithValue(guest),
    ]);
    addTearDown(container.dispose);

    expect(
        (await container.read(currencyControllerProvider.future)).code, 'MGA');
    await container
        .read(currencyControllerProvider.notifier)
        .setCurrency('EUR');

    final state = container.read(currencyControllerProvider).requireValue;
    expect(state.preferredCode, 'EUR');
    expect(state.code, 'MGA');
    final profile = await database.customSelect(
      'SELECT currency_code FROM guest_profiles WHERE id=?',
      variables: [Variable.withString(guest.userId)],
    ).getSingle();
    expect(profile.read<String>('currency_code'), 'EUR');
    final journal = await database
        .customSelect(
          "SELECT payload FROM guest_sync_records WHERE table_name='user'",
        )
        .get();
    expect(journal.single.read<String>('payload'), contains('EUR'));
    container.invalidate(currencyControllerProvider);
    final reloaded = await container.read(currencyControllerProvider.future);
    expect(reloaded.preferredCode, 'EUR');
    expect(reloaded.code, 'MGA');
    expect(
      await container
          .read(currencyControllerProvider.notifier)
          .retryGuestRates(),
      false,
    );
    expect(container.read(currencyControllerProvider).requireValue.code, 'MGA');
  });
}
