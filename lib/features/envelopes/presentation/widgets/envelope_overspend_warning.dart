import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_amount.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class EnvelopeOverspendWarning extends StatelessWidget {
  const EnvelopeOverspendWarning({
    required this.envelope,
    this.displayCurrency,
    super.key,
  });

  final Envelope envelope;
  final CurrencyState? displayCurrency;

  @override
  Widget build(BuildContext context) {
    final amount = displayCurrency?.convertToSelected(
          envelope.overspentAmount,
          envelope.currencyCode,
        ) ??
        envelope.overspentAmount;
    return Container(
      key: const Key('envelope-overspend-warning'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppTextTheme.envelopeWarningBackground(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: PrivacyText(
        context.l10n.envelopeOverBy(EnvelopeAmount.compact(amount)),
        style: AppTextTheme.envelopeWarning(context),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
