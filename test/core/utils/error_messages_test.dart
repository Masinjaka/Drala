import 'package:budgets/core/utils/error_messages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('retryable refresh failures use the localized connectivity message', () {
    final error = AuthRetryableFetchException(
      message:
          "ClientException with SocketException: Failed host lookup: 'example.supabase.co'",
    );
    const message = 'Check your connection and try again.';
    expect(friendlyErrorMessage(error, networkMessage: message), message);
    expect(friendlyErrorMessage(error), contains('connexion internet'));
  });

  test('invalid credentials keep their existing authentication message', () {
    expect(
        friendlyErrorMessage(const AuthException('Invalid login credentials'),
            networkMessage: 'Offline'),
        'Email ou mot de passe incorrect.');
  });
}
