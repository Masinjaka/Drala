import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:flutter/material.dart';
import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';

class StatsAmount extends StatelessWidget {
  const StatsAmount(
      {required this.value,
      this.currencyCode,
      this.size = 22,
      this.currencySize = 11,
      this.maskValue = true,
      this.sign = '',
      this.emphasize = true,
      this.style,
      super.key});
  final num value;
  final String? currencyCode;
  final double size;
  final double currencySize;
  final bool maskValue;
  final String sign;
  final bool emphasize;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    if (maskValue && !AmountVisibilityScope.isVisibleOf(context)) {
      return Text('***', style: style ?? AppStatsTheme.amount(context, size));
    }
    final symbol = currencyCode == 'MGA'
        ? 'Ar'
        : currencyCode == null
            ? ''
            : currencySymbolForCode(currencyCode!);
    final amount = formatAmountForInput(value.round());
    final amountStyle = style ??
        (currencyCode == null
            ? AppStatsTheme.label(context)
            : emphasize
                ? AppStatsTheme.amount(context, size)
                : AppStatsTheme.currency(context, size));
    return Semantics(
      label: '${symbol.isEmpty ? sign : '$sign$symbol '}$amount',
      excludeSemantics: true,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (symbol.isNotEmpty) ...[
              Text('$sign$symbol',
                  style: AppStatsTheme.currency(context, currencySize)),
              const SizedBox(width: 4),
            ],
            if (MediaQuery.disableAnimationsOf(context))
              Text('${symbol.isEmpty ? sign : ''}$amount', style: amountStyle)
            else
              AnimatedCompactAmount(
                  value: value.round(),
                  style: amountStyle,
                  prefix: symbol.isEmpty ? sign : '',
                  compact: false,
                  beginNearTarget: true,
                  amountTypography: false,
                  respectAmountVisibility: maskValue),
          ]),
    );
  }
}
