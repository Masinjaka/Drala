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
  test('sign-in suspends unfinished guest setup without deleting its draft',
      () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    await guest.onboarding
        .save({'step': 3, 'language': 'fr', 'currency': 'EUR'});
    final id = guest.userId;
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(_SignInRepository()),
      guestSessionProvider.overrideWithValue(guest),
    ]);
    addTearDown(container.dispose);
    await container
        .read(authControllerProvider.notifier)
        .signIn(email: 'returning@example.com', password: 'test-password');
    expect(guest.isActive, isFalse);
    final restored = await GuestSession.load(database);
    expect(restored.isActive, isFalse);
    expect(restored.userId, id);
    expect(restored.onboarding.draft['step'], 3);
    expect(restored.onboarding.draft['currency'], 'EUR');
  });
}

class _SignInRepository implements AuthRepository {
  @override
  Future<void> signInWithPassword(
      {required String email, required String password}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
