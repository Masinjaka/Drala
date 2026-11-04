import 'package:budgets/core/utils/finance_failure_code.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';

String? financeErrorMessage(Object error, AppLocalizations l10n) =>
    switch (FinanceFailureCode.fromError(error)) {
      FinanceFailureCode.insufficientFunds => l10n.insufficientWalletFunds,
      FinanceFailureCode.walletInUse => l10n.walletInUseCannotBeDeleted,
      FinanceFailureCode.envelopeAmountBelowSpent =>
        l10n.envelopeAmountBelowSpent,
      FinanceFailureCode.monthlyScheduleNotLatest =>
        l10n.monthlyScheduleNotLatest,
      FinanceFailureCode.sameWalletTransfer => l10n.differentTransferWallets,
      FinanceFailureCode.walletCurrencyMismatch => l10n.walletCurrencyMismatch,
      FinanceFailureCode.walletUnavailable => l10n.walletUnavailable,
      FinanceFailureCode.transferConflict => l10n.transferConflict,
      FinanceFailureCode.defaultWalletCannotDelete =>
        l10n.defaultWalletCannotDelete,
      FinanceFailureCode.envelopeUnavailable => l10n.envelopeUnavailable,
      FinanceFailureCode.operationInProgress => l10n.operationInProgress,
      null => null,
    };
