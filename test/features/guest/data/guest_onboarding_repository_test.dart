import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_onboarding_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('onboarding persists selected categories and wallets once', () async {
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    await database.customInsert(
      '''INSERT INTO guest_profiles
         (id,currency_code,language_code,theme_mode,onboarding_complete,created_at)
         VALUES(?,?,?,?,?,?)''',
      variables: [
        Variable.withString('guest'),
        Variable.withString('MGA'),
        Variable.withString('en'),
        Variable.withString('system'),
        Variable.withInt(0),
        Variable.withString('2026-01-01T00:00:00Z'),
      ],
    );
    final onboarding = GuestOnboardingRepository(database, 'guest');
    await onboarding.save({'step': 4, 'currency': 'EUR'});
    final resumed = GuestOnboardingRepository(database, 'guest');
    await resumed.loadDraft();
    expect(resumed.draft['step'], 4);

    Future<void> complete() => resumed.complete(
          currency: 'EUR',
          language: 'de',
          categories: ['food', 'salary'],
          wallets: ['cash'],
        );
    await complete();
    await complete();

    final profile = await database
        .customSelect(
          'SELECT currency_code,language_code,onboarding_complete FROM guest_profiles',
        )
        .getSingle();
    expect(profile.read<String>('currency_code'), 'EUR');
    expect(profile.read<String>('language_code'), 'de');
    expect(profile.read<int>('onboarding_complete'), 1);
    final categories =
        await database.customSelect('SELECT name FROM guest_categories').get();
    expect(categories.map((row) => row.read<String>('name')),
        containsAll(['Essen & Trinken', 'Gehalt']));
    final savedWallets = await database
        .customSelect('SELECT name FROM guest_wallets ORDER BY name')
        .get();
    expect(savedWallets.map((row) => row.read<String>('name')),
        containsAll(['Hauptkonto', 'Bargeld']));
  });
}
