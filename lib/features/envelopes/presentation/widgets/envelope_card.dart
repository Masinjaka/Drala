import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card_heading.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_card_amounts.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_overspend_warning.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_progress.dart';
import 'package:flutter/material.dart';

class EnvelopeCard extends StatelessWidget {
  const EnvelopeCard(
      {required this.envelope,
      required this.onDelete,
      this.displayCurrency,
      this.onTap,
      this.loading = false,
      this.isFirst = true,
      this.isLast = true,
      super.key});
  final Envelope envelope;
  final VoidCallback? onTap;
  final bool loading;
  final VoidCallback onDelete;
  final CurrencyState? displayCurrency;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: loading ? null : onTap,
        onLongPress: loading ? null : (onTap ?? onDelete),
        child: Container(
          key: const Key('envelope-card-surface'),
          padding: const EdgeInsets.fromLTRB(15, 13, 15, 18),
          decoration: BoxDecoration(
              boxShadow: AppEnvelopeTheme.shadows(context),
              color: AppEnvelopeTheme.surface(context),
              borderRadius:
                  AppEnvelopeTheme.cardRadius(first: isFirst, last: isLast)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            EnvelopeCardHeading(envelope: envelope),
            const SizedBox(height: 16),
            EnvelopeCardAmounts(
                spent: _convert(envelope.spent),
                budget: _convert(envelope.amount),
                currencyCode: displayCurrency?.code ?? envelope.currencyCode,
                loading: loading),
            const SizedBox(height: 12),
            if (loading)
              const ValueSkeleton(width: double.infinity, height: 5)
            else
              EnvelopeProgress(
                  value: envelope.progress.clamp(0, 1),
                  foregroundColor: AppEnvelopeTheme.progress(context,
                      exceeded: envelope.isExceeded || envelope.remaining < 0)),
            if (envelope.isExceeded && !loading) ...[
              const SizedBox(height: 8),
              EnvelopeOverspendWarning(
                  envelope: envelope, displayCurrency: displayCurrency),
            ],
          ]),
        ),
      );

  num _convert(num amount) =>
      displayCurrency?.convertToSelected(amount, envelope.currencyCode) ??
      amount;
}
