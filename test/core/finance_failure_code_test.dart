import 'package:budgets/core/utils/finance_failure_code.dart';
import 'package:budgets/core/utils/finance_error_message.dart';
import 'package:budgets/features/home/domain/errors/wallet_deletion_exception.dart';
import 'package:budgets/features/home/domain/errors/wallet_selection_required_exception.dart';
import 'package:budgets/l10n/generated/app_localizations_en.dart';
import 'package:budgets/l10n/generated/app_localizations_mg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('guest and server funding failures have the same stable code', () {
    for (final error in [
      const WalletSelectionRequiredException(requiredAmount: 200),
      const PostgrestException(message: 'insufficient_funds:200:100'),
      const PostgrestException(message: 'wallet_selection_required:200'),
    ]) {
      expect(FinanceFailureCode.fromError(error),
          FinanceFailureCode.insufficientFunds);
      final message = financeErrorMessage(error, AppLocalizationsEn())!;
      expect(message, contains('enough funds'));
      expect(message, isNot(contains('try again')));
      expect(financeErrorMessage(error, AppLocalizationsMg()),
          isNot(equals(message)));
    }
  });

  test('wallet use and spent-budget errors explain the actual constraint', () {
    expect(
        FinanceFailureCode.fromError(
            const WalletDeletionException.defaultWallet()),
        FinanceFailureCode.defaultWalletCannotDelete);
    expect(FinanceFailureCode.fromError(const WalletDeletionException.inUse()),
        FinanceFailureCode.walletInUse);
    for (final error in [
      StateError('Envelope amount cannot be below the amount spent.'),
      const PostgrestException(message: 'envelope_amount_below_spent'),
    ]) {
      expect(FinanceFailureCode.fromError(error),
          FinanceFailureCode.envelopeAmountBelowSpent);
    }
    expect(financeErrorMessage(Exception('unknown'), AppLocalizationsEn()),
        isNull);
  });
}
