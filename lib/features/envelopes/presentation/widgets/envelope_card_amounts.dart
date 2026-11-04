import 'package:budgets/core/ui/app_envelope_theme.dart';
import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/features/envelopes/presentation/widgets/envelope_amount.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class EnvelopeCardAmounts extends StatelessWidget {
  const EnvelopeCardAmounts(
      {required this.spent,
      required this.budget,
      required this.currencyCode,
      required this.loading,
      super.key});
  final num spent;
  final num budget;
  final String currencyCode;
  final bool loading;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
            child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Row(children: [
                  if (loading)
                    const ValueSkeleton(
                        key: Key('envelope-spent-skeleton'),
                        width: 64,
                        height: 18)
                  else
                    EnvelopeAmount(value: spent, currencyCode: currencyCode),
                  const SizedBox(width: 8),
                  Text(context.l10n.spent,
                      style: AppEnvelopeTheme.label(context)),
                ]))),
        const SizedBox(width: 8),
        Expanded(
            child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: Row(children: [
                  Text(context.l10n.envelopeBudgetOf,
                      style: AppEnvelopeTheme.label(context)),
                  const SizedBox(width: 8),
                  if (loading)
                    const ValueSkeleton(
                        key: Key('envelope-budget-skeleton'),
                        width: 56,
                        height: 18)
                  else
                    EnvelopeAmount(value: budget, currencyCode: currencyCode),
                ]))),
      ]);
}
