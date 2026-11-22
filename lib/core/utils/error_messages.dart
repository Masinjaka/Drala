import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Turns any error into a short message in the user's selected language.
///
/// Raw server and exception text is never shown: unknown errors fall back to
/// a generic localized message.
String friendlyErrorMessage(Object error, AppLocalizations l10n) =>
    switch (error) {
      AuthRetryableFetchException() => l10n.networkUnavailable,
      AuthException() => _auth(error.message, l10n),
      PostgrestException() => _postgrest(error.message, l10n),
      StorageException() => _storage(error.message, l10n),
      StateError() => _generic(error.message, l10n),
      Exception() => _generic(error.toString(), l10n),
      _ => l10n.genericError,
    };

String _auth(String message, AppLocalizations l10n) {
  final text = message.toLowerCase();
  bool has(List<String> parts) => parts.any(text.contains);
  if (has(['invalid login', 'invalid_credentials'])) {
    return l10n.invalidCredentials;
  }
  if (has(['email not confirmed', 'email_not_confirmed'])) {
    return l10n.emailNotConfirmed;
  }
  if (has(['user not found'])) return l10n.accountNotFound;
  if (has([
    'already registered',
    'duplicate key value',
    'user already exists',
    'email already',
  ])) {
    return l10n.emailAlreadyUsed;
  }
  if (has([
    'missing email',
    'missing password',
    'email is required',
    'password is required',
  ])) {
    return l10n.emailPasswordRequired;
  }
  if (has(['invalid email'])) return l10n.invalidEmail;
  if (has(
      ['password should be at least', 'weak_password', 'password is too'])) {
    return l10n.weakPassword;
  }
  return _generic(message, l10n);
}

String _postgrest(String message, AppLocalizations l10n) {
  final text = message.toLowerCase();
  if (text.contains('violates foreign key') ||
      text.contains('violates not-null') ||
      text.contains('null value')) {
    return l10n.checkRequiredFields;
  }
  if (text.contains('duplicate key value')) return l10n.duplicateEntry;
  return l10n.serverError;
}

String _storage(String message, AppLocalizations l10n) {
  final text = message.toLowerCase();
  if (text.contains('permission') || text.contains('not authorized')) {
    return l10n.accessDenied;
  }
  if (text.contains('not found')) return l10n.fileNotFound;
  return l10n.fileProcessingFailed;
}

/// Known app-thrown messages; anything else gets the generic message.
String _generic(String message, AppLocalizations l10n) {
  final text = message.toLowerCase();
  if (text.contains('user not authenticated') ||
      text.contains('no authenticated user') ||
      text.contains('no authenticated session') ||
      text.startsWith('please sign in')) {
    return l10n.signInToContinue;
  }
  if (text.contains('no camera is available')) return l10n.noCameraAvailable;
  if (text.contains('smaller than 15 mb')) return l10n.receiptFileTooLarge;
  if (text.contains('only jpg, png, and pdf')) {
    return l10n.receiptFormatUnsupported;
  }
  if (text.contains('receipt scanning is unavailable')) {
    return l10n.receiptScanningUnavailable;
  }
  return l10n.genericError;
}
