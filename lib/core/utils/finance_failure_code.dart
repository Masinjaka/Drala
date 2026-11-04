import 'package:budgets/features/home/domain/errors/insufficient_funds_exception.dart';
import 'package:budgets/features/home/domain/errors/wallet_deletion_exception.dart';
import 'package:budgets/features/home/domain/errors/wallet_selection_required_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum FinanceFailureCode {
  insufficientFunds,
  walletInUse,
  envelopeAmountBelowSpent,
  monthlyScheduleNotLatest,
  sameWalletTransfer,
  walletCurrencyMismatch,
  walletUnavailable,
  transferConflict,
  defaultWalletCannotDelete,
  envelopeUnavailable,
  operationInProgress;

  static FinanceFailureCode? fromError(Object error) {
    if (error is WalletDeletionException) {
      return error.reason == WalletDeletionReason.defaultWallet
          ? defaultWalletCannotDelete
          : walletInUse;
    }
    if (error is InsufficientFundsException ||
        error is WalletSelectionRequiredException) {
      return insufficientFunds;
    }
    final message = switch (error) {
      PostgrestException() => error.message,
      StateError() => error.message,
      _ => '',
    };
    final normalized = message.toLowerCase();
    if (normalized == 'operation_in_progress') return operationInProgress;
    if (normalized.startsWith('insufficient_funds:') ||
        normalized.startsWith('wallet_selection_required:') ||
        normalized == 'the source wallet has insufficient funds.') {
      return insufficientFunds;
    }
    if (normalized == 'default_wallet_cannot_be_deleted' ||
        normalized == 'the default wallet cannot be deleted.') {
      return defaultWalletCannotDelete;
    }
    if (normalized == 'envelope_not_found') return envelopeUnavailable;
    if (normalized == 'same_wallet_transfer') return sameWalletTransfer;
    if (normalized == 'wallet_currency_mismatch') return walletCurrencyMismatch;
    if (normalized == 'wallet_not_found') return walletUnavailable;
    if (normalized == 'transfer_id_conflict') return transferConflict;
    if (normalized == 'wallet_in_use') return walletInUse;
    if (normalized == 'envelope_amount_below_spent' ||
        normalized == 'envelope amount cannot be below the amount spent.') {
      return envelopeAmountBelowSpent;
    }
    if (normalized == 'monthly_schedule_not_latest') {
      return monthlyScheduleNotLatest;
    }
    return null;
  }
}
