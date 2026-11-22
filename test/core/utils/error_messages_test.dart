import 'package:budgets/core/utils/error_messages.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  final fr = lookupAppLocalizations(const Locale('fr'));
  final de = lookupAppLocalizations(const Locale('de'));

  test('retryable refresh failures use the connectivity message', () {
    final error = AuthRetryableFetchException(
      message:
          "ClientException with SocketException: Failed host lookup: 'example.supabase.co'",
    );
    expect(friendlyErrorMessage(error, en), en.networkUnavailable);
    expect(friendlyErrorMessage(error, fr), fr.networkUnavailable);
  });

  test('follows the selected language instead of always French', () {
    const error = AuthException('Invalid login credentials');
    expect(friendlyErrorMessage(error, en), 'Incorrect email or password.');
    expect(friendlyErrorMessage(error, fr), 'Email ou mot de passe incorrect.');
    expect(friendlyErrorMessage(error, de), de.invalidCredentials);
  });

  test('maps app-thrown receipt and camera errors', () {
    expect(
        friendlyErrorMessage(
            StateError('No camera is available on this device.'), de),
        de.noCameraAvailable);
    expect(
        friendlyErrorMessage(
            StateError('Each receipt file must be smaller than 15 MB.'), fr),
        fr.receiptFileTooLarge);
    expect(friendlyErrorMessage(StateError('Please sign in to view receipts.'), en),
        en.signInToContinue);
  });

  test('never leaks raw exception text', () {
    expect(friendlyErrorMessage(StateError('internal detail xyz'), fr),
        fr.genericError);
    expect(friendlyErrorMessage(const PostgrestException(message: 'boom'), de),
        de.serverError);
    expect(friendlyErrorMessage('not an exception', en), en.genericError);
  });
}
