import 'package:budgets/features/home/presentation/widgets/home_balance_eye_painter.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_primary_amount.dart';
import 'package:budgets/features/home/presentation/widgets/home_colors.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeBalanceCard extends StatelessWidget {
  const HomeBalanceCard({
    required this.balance,
    required this.income,
    required this.expenses,
    required this.currencyCode,
    this.isLoading = false,
    super.key,
  });

  final num balance;
  final num income;
  final num expenses;
  final String currencyCode;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('home-balance-card'),
      height: 109,
      decoration: BoxDecoration(
        color: HomeColors.banner,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.availableBalance,
                  key: const Key('home-balance-label'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _labelStyle,
                ),
              ),
              const SizedBox(
                key: Key('home-balance-eye'),
                width: 23,
                height: 16,
                child: CustomPaint(painter: HomeBalanceEyePainter()),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomLeft,
            child: HomeBalancePrimaryAmount(
              balance: balance,
              currencyCode: currencyCode,
              isLoading: isLoading,
              amountStyle: _balanceStyle,
              currencyStyle: _labelStyle,
              onCompleted: _onAmountCompleted,
            ),
          ),
        ],
      ),
    );
  }

  static void _onAmountCompleted() {}

  static const _labelStyle = TextStyle(
    color: Color(0xFFF4F4F4),
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 17 / 12,
  );
  static const _balanceStyle = TextStyle(
    color: Color(0xFFF4F4F4),
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 38 / 36,
  );
}
