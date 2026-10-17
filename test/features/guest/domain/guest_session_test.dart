import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('account choice persists and a post-sync guest starts fresh', () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    await guest.onboarding.complete(
      currency: 'MGA',
      language: 'en',
      categories: const [],
      wallets: const [],
    );
    guest.markOnboardingComplete();
    expect(guest.accountChoiceSeen, false);
    await guest.markChoiceSeen();
    final reloaded = await GuestSession.load(database);
    expect(reloaded.accountChoiceSeen, true);
    expect(reloaded.onboardingComplete, true);
    final importedId = guest.userId;
    await guest.stopAfterSync();
    await guest.start();
    expect(guest.userId, isNot(importedId));
    expect(guest.onboardingComplete, false);
    expect(guest.accountChoiceSeen, false);
  });

  test('sign-out opens a fresh guest account ready for Activities', () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    await guest.onboarding.complete(
      currency: 'MGA',
      language: 'en',
      categories: const [],
      wallets: const [],
    );
    guest.markOnboardingComplete();
    await guest.stopAfterSync();
    final oldId = guest.userId;

    await guest.enterAfterSignOut(currency: 'MGA', language: 'fr');

    expect(guest.userId, isNot(oldId));
    expect(guest.isActive, isTrue);
    expect(guest.onboardingComplete, isTrue);
    expect(guest.accountChoiceSeen, isTrue);
    final reloaded = await GuestSession.load(database);
    expect(reloaded.onboardingComplete, isTrue);
    expect(reloaded.accountChoiceSeen, isTrue);
    final wallets = await guest.repositories.wallets.wallets();
    expect(wallets, isNotEmpty);
  });
}
