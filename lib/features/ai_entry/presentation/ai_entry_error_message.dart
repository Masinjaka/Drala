import 'package:budgets/features/ai_entry/domain/errors/ai_entry_exception.dart';
import 'package:budgets/l10n/generated/app_localizations.dart';

/// Maps AI service error codes to the user's language.
///
/// The server's own English `message` is never shown; unknown codes get a
/// generic localized message.
String? aiEntryErrorMessage(Object error, AppLocalizations l10n) {
  if (error is! AiEntryException) return null;
  return switch (error.code) {
    'provider_timeout' || 'request_timeout' => l10n.aiRequestTimedOut,
    'unauthorized' => l10n.signInToContinue,
    'daily_limit_exceeded' ||
    'guest_ai_rate_limited' ||
    'guest_ai_ip_limit' ||
    'guest_ai_global_limit' =>
      l10n.aiDailyLimitReached,
    'rate_limited' => l10n.aiRateLimited,
    'invalid_model_response' => l10n.aiUnreadableResponse,
    'future_date_not_allowed' => l10n.futureDateNotAllowed,
    'invalid_request' => l10n.invalidEntryRequest,
    'invalid_converted_amount' => l10n.amountOutOfRange,
    'exchange_rate_unavailable' => l10n.exchangeRateUnavailable,
    'invalid_receipt' => l10n.receiptUnreadable,
    'receipt_too_large' => l10n.receiptTooLarge,
    'unsupported_receipt_format' => l10n.receiptPdfUnsupported,
    'receipt_not_found' => l10n.receiptNotFound,
    'insufficient_funds' => l10n.insufficientFundsAllWallets,
    'wallet_funding_declined' => l10n.transactionNotCompletedInsufficientFunds,
    'provider_not_configured' ||
    'server_not_configured' ||
    'provider_auth_error' ||
    'provider_error' ||
    'provider_quota_exceeded' =>
      l10n.aiServiceUnavailable,
    _ => l10n.genericError,
  };
}
