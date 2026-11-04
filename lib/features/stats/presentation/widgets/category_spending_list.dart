import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_stats_theme.dart';
import 'package:budgets/features/stats/domain/models/monthly_stats.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'stats_category_row.dart';

class CategorySpendingList extends StatelessWidget {
  const CategorySpendingList(
      {required this.categories,
      required this.total,
      required this.currencyCode,
      this.displayCurrency,
      super.key});
  final List<CategoryStat> categories;
  final int total;
  final String currencyCode;
  final CurrencyState? displayCurrency;
  @override
  Widget build(BuildContext context) => categories.isEmpty
      ? Padding(
          padding: const EdgeInsets.all(24),
          child: Text(context.l10n.statsEmptyCategories,
              textAlign: TextAlign.center, style: AppStatsTheme.label(context)))
      : Column(children: [
          for (var i = 0; i < categories.length; i++) ...[
            StatsCategoryRow(
                category: categories[i],
                total: total,
                last: i == categories.length - 1,
                value: displayCurrency?.convertToSelected(
                        categories[i].amount, currencyCode) ??
                    categories[i].amount,
                currencyCode: displayCurrency?.code ?? currencyCode),
            if (i < categories.length - 1) const SizedBox(height: 4),
          ]
        ]);
}
