import 'package:budgets/core/monitoring/development_log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class AuthStateErrorHandler {
  /// A failed refresh is a stream error, not a signed-out event. Keep listening
  /// so Supabase can recover the existing session when connectivity returns.
  static void handle(Object error, StackTrace stackTrace) {
    DevelopmentLog.error(
      'auth state',
      error,
      error is AuthRetryableFetchException ? null : stackTrace,
    );
  }
}
