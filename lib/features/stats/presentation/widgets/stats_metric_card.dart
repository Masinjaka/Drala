import 'package:budgets/core/ui/value_skeleton.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';
import 'package:flutter/material.dart';

class StatsMetricCard extends StatelessWidget {
  const StatsMetricCard(
      {required this.label,
      required this.value,
      required this.emoji,
      this.valueColor,
      this.loading = false,
      this.currencyCode,
      this.maskValue = true,
      super.key});
  final String label;
  final num value;
  final String emoji;
  final Color? valueColor;
  final bool loading;
  final bool maskValue;
  final String? currencyCode;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        height: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
            Text(emoji, style: theme.textTheme.titleMedium)
          ]),
          const Spacer(),
          if (loading)
            const ValueSkeleton(key: Key('stats-value-skeleton'))
          else
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedCompactAmount(
                    value: value,
                    respectAmountVisibility: maskValue,
                    amountTypography: currencyCode != null,
                    style: theme.textTheme.headlineMedium!
                        .copyWith(color: valueColor),
                  ),
                  if (currencyCode != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      currencySymbolForCode(currencyCode!),
                      style: AppTextTheme.currencyLabel(context).copyWith(
                        color: valueColor ?? theme.textTheme.labelMedium?.color,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ]));
  }
}
