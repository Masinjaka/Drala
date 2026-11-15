import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/ui/app_settings_theme.dart';
import 'package:flutter/material.dart';

enum SettingsSummaryCardType { categories, wallets }

class SettingsSummaryCard extends StatelessWidget {
  const SettingsSummaryCard({
    required this.type,
    required this.title,
    required this.count,
    required this.onTap,
    super.key,
  });

  final SettingsSummaryCardType type;
  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCardSurface(
        color: AppSettingsTheme.surface(context),
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(
                    type == SettingsSummaryCardType.categories
                        ? Icons.category
                        : Icons.account_balance_wallet,
                    color: AppSettingsTheme.summaryIcon(context),
                    size: 24,
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_rounded,
                      size: 18,
                      color: AppSettingsTheme.iconForeground(context)),
                ]),
                const SizedBox(height: 16),
                Text(title, style: AppSettingsTheme.summaryTitle(context)),
                const SizedBox(height: 8),
                Text('$count', style: AppSettingsTheme.summaryCount(context)),
              ],
            ),
          ),
        ),
      );
}
