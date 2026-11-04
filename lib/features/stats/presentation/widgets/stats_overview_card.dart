import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_card_theme.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:flutter/material.dart';

class StatsOverviewCard extends StatelessWidget {
  const StatsOverviewCard({required this.stats, super.key});

  final MonthlyStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppCardTheme.shadows(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Net this month',
            style: AppTextStyle(AppTextRole.body, color: Color(0xFFAFAFAF)),
          ),
          const SizedBox(height: 6),
          PrivacyText(
            formatAmountWithCurrency(stats.balance, stats.currencyCode),
            style: const AppTextStyle(AppTextRole.display, color: Colors.white),
          ),
          const SizedBox(height: 19),
          Row(
            children: [
              Expanded(
                child: _value(
                  'Income',
                  stats.income,
                  AppTheme.primaryGreen,
                ),
              ),
              Expanded(
                child: _value(
                  'Expenses',
                  stats.expenses,
                  AppTheme.palettePeach,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _value(String label, int amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const AppTextStyle(AppTextRole.supporting,
                color: Color(0xFF969696))),
        const SizedBox(height: 4),
        PrivacyText(
          formatAmountWithCurrency(amount, stats.currencyCode),
          style: AppTextStyle(AppTextRole.body, color: color),
        ),
      ],
    );
  }
}
