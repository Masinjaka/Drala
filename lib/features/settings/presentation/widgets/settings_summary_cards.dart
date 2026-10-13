import 'package:budgets/features/settings/presentation/widgets/settings_summary_card.dart';
import 'package:flutter/material.dart';

class SettingsSummaryCards extends StatelessWidget {
  const SettingsSummaryCards({
    required this.categoriesLabel,
    required this.walletsLabel,
    required this.categoryCount,
    required this.walletCount,
    required this.onCategories,
    required this.onWallets,
    super.key,
  });

  final String categoriesLabel;
  final String walletsLabel;
  final int categoryCount;
  final int walletCount;
  final VoidCallback onCategories;
  final VoidCallback onWallets;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: SettingsSummaryCard(
              type: SettingsSummaryCardType.categories,
              title: categoriesLabel,
              count: categoryCount,
              onTap: onCategories,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SettingsSummaryCard(
              type: SettingsSummaryCardType.wallets,
              title: walletsLabel,
              count: walletCount,
              onTap: onWallets,
            ),
          ),
        ],
      );
}
