import 'package:budgets/features/auth/domain/interfaces/auth_repository.dart';
import 'package:budgets/features/auth/domain/providers/auth_providers.dart';
import 'package:budgets/features/auth/presentation/controllers/auth_controller.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('sign-out prepares the guest Activities destination', () async {
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
    await guest.markChoiceSeen();
    await guest.stopAfterSync();
    final syncedGuestId = guest.userId;
    final auth = _SignOutRepository(guest);
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(auth),
      guestSessionProvider.overrideWithValue(guest),
    ]);
    addTearDown(container.dispose);

    await container.read(authControllerProvider.notifier).signOut();

    expect(auth.signOutCount, 1);
    expect(guest.isSigningOut, isFalse);
    expect(guest.userId, isNot(syncedGuestId));
    expect(guest.isActive, isTrue);
    expect(guest.onboardingComplete, isTrue);
    expect(guest.accountChoiceSeen, isTrue);
  });
}

class _SignOutRepository implements AuthRepository {
  _SignOutRepository(this.guest);

  final GuestSession guest;
  int signOutCount = 0;

  @override
  Future<void> signOut() async {
    expect(guest.isSigningOut, isTrue);
    signOutCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
