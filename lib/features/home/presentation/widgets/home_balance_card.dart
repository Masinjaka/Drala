import 'package:budgets/features/home/presentation/widgets/animated_compact_amount.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_eye_painter.dart';
import 'package:budgets/features/home/presentation/widgets/home_balance_primary_amount.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class HomeBalanceCard extends StatefulWidget {
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
  State<HomeBalanceCard> createState() => _HomeBalanceCardState();
}

class _HomeBalanceCardState extends State<HomeBalanceCard> {
  final _showMonthlyTotals = ValueNotifier(false);

  @override
  void didUpdateWidget(covariant HomeBalanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading ||
        oldWidget.isLoading != widget.isLoading ||
        oldWidget.balance != widget.balance) {
      _showMonthlyTotals.value = false;
    }
  }

  void _revealMonthlyTotals() {
    if (_showMonthlyTotals.value || widget.isLoading || !mounted) return;
    _showMonthlyTotals.value = true;
  }

  @override
  void dispose() {
    _showMonthlyTotals.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('home-balance-card'),
      height: 110,
      decoration: BoxDecoration(
        color: const Color(0xFF343434),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 22, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(width: 12),
              const SizedBox(
                key: Key('home-balance-eye'),
                width: 23,
                height: 16,
                child: CustomPaint(painter: HomeBalanceEyePainter()),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: HomeBalancePrimaryAmount(
                    balance: widget.balance,
                    currencyCode: widget.currencyCode,
                    isLoading: widget.isLoading,
                    amountStyle: _balanceStyle,
                    currencyStyle: _labelStyle,
                    onCompleted: _revealMonthlyTotals,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _showMonthlyTotals,
                  builder: (context, showMonthlyTotals, _) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: showMonthlyTotals && !widget.isLoading
                        ? Column(
                            key: const Key('home-balance-monthly-group'),
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.thisMonth,
                                key: const Key('home-balance-month-label'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: _monthStyle,
                              ),
                              const SizedBox(height: 4),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedCompactAmount(
                                      value: widget.income,
                                      key: const Key('home-balance-income'),
                                      prefix: '+',
                                      style: _monthlyAmountStyle,
                                      beginNearTarget: true,
                                    ),
                                    const SizedBox(width: 10),
                                    AnimatedCompactAmount(
                                      value: widget.expenses,
                                      key: const Key('home-balance-expenses'),
                                      prefix: '-',
                                      style: _monthlyAmountStyle.copyWith(
                                        color: const Color(0xFFF25959),
                                      ),
                                      beginNearTarget: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(
                            key: Key('home-balance-monthly-placeholder'),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
  static const _monthStyle = TextStyle(
    color: Color(0xFFF4F4F4),
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );
  static const _monthlyAmountStyle = TextStyle(
    color: Color(0xFFF4F4F4),
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 18 / 16,
  );
}
