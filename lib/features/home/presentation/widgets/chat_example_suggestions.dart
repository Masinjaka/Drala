import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/widgets.dart';

class ChatExampleSuggestions {
  const ChatExampleSuggestions._();

  static List<String> build(BuildContext context, String currencyCode) {
    final usesMga = currencyCode.toUpperCase() == 'MGA';
    String amount(num mga, num other) => formatAmountWithCurrency(
          usesMga ? mga : other,
          currencyCode,
        );

    return [
      context.l10n.expenseSuggestion(amount(30000, 9)),
      context.l10n.incomeSuggestion(amount(1200000, 1200)),
      context.l10n.transferSuggestion(amount(200000, 50)),
    ];
  }
}
