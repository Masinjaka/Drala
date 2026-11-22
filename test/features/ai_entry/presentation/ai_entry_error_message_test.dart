import 'package:budgets/features/ai_entry/domain/errors/ai_entry_exception.dart';
import 'package:budgets/features/ai_entry/presentation/ai_entry_error_message.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

AiEntryException _error(String code) => AiEntryException(
    code: code, message: 'English text from the server for $code');

void main() {
  final it = lookupAppLocalizations(const Locale('it'));
  final mg = lookupAppLocalizations(const Locale('mg'));

  test('ignores errors that are not from the AI service', () {
    expect(aiEntryErrorMessage(StateError('x'), it), isNull);
  });

  test('translates known AI service codes', () {
    expect(aiEntryErrorMessage(_error('daily_limit_exceeded'), it),
        it.aiDailyLimitReached);
    expect(aiEntryErrorMessage(_error('provider_timeout'), mg),
        mg.aiRequestTimedOut);
    expect(aiEntryErrorMessage(_error('receipt_too_large'), it),
        it.receiptTooLarge);
    expect(aiEntryErrorMessage(_error('provider_quota_exceeded'), mg),
        mg.aiServiceUnavailable);
  });

  test('never shows the server English message, even for unknown codes', () {
    for (final code in ['internal_error', 'something_new', 'function_error']) {
      final message = aiEntryErrorMessage(_error(code), it)!;
      expect(message, it.genericError);
      expect(message, isNot(contains('English text')));
    }
  });
}
