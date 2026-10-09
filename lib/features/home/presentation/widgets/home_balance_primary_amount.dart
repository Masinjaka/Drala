import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';
import 'package:flutter/material.dart';

class HomeBalancePrimaryAmount extends StatelessWidget {
  const HomeBalancePrimaryAmount({
    required this.balance,
    required this.currencyCode,
    required this.isLoading,
    required this.amountStyle,
    required this.currencyStyle,
    required this.onCompleted,
    super.key,
  });

  final num balance;
  final String currencyCode;
  final bool isLoading;
  final TextStyle amountStyle;
  final TextStyle currencyStyle;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Text(
        '-',
        key: const Key('home-balance-loading-amount'),
        style: amountStyle,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedCompactAmount(
          value: balance,
          key: const Key('home-balance-amount'),
          style: amountStyle,
          beginNearTarget: true,
          onCompleted: onCompleted,
        ),
        const SizedBox(width: 8),
        Text(
          currencySymbolForCode(currencyCode),
          key: const Key('home-balance-currency'),
          maxLines: 1,
          style: currencyStyle,
        ),
      ],
    );
  }
}
