import 'package:budgets/core/ui/amount_visibility_scope.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:flutter/material.dart';

class HomeOverviewAmount extends StatelessWidget {
  const HomeOverviewAmount(
      {required this.amount,
      required this.currencyCode,
      required this.style,
      this.sign = '',
      this.loading = false,
      super.key});
  final num amount;
  final String currencyCode;
  final TextStyle style;
  final String sign;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final symbol =
        currencyCode == 'MGA' ? 'Ar' : currencySymbolForCode(currencyCode);
    final value = loading
        ? '—'
        : AmountVisibilityScope.isVisibleOf(context)
            ? '$sign$symbol ${formatAmountForInput(amount, preserveFraction: true)}'
            : '••••';
    return Text(value,
        maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
  }
}
