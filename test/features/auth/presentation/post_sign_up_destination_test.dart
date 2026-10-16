import 'package:budgets/features/auth/presentation/post_sign_up_destination.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signed-up guest with a session skips cloud onboarding', () {
    expect(
      postSignUpDestination(
        hasSession: true,
        completedGuestOnboarding: true,
      ),
      '/home',
    );
  });

  test('guest awaiting email confirmation keeps using local home', () {
    expect(
      postSignUpDestination(
        hasSession: false,
        completedGuestOnboarding: true,
      ),
      '/home',
    );
  });

  test('new account with a session starts onboarding', () {
    expect(
      postSignUpDestination(
        hasSession: true,
        completedGuestOnboarding: false,
      ),
      '/onboarding',
    );
  });

  test('new account without a session waits on login', () {
    expect(
      postSignUpDestination(
        hasSession: false,
        completedGuestOnboarding: false,
      ),
      '/login',
    );
  });
}
