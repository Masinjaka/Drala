import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/core/ui/app_danger_theme.dart';
import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:budgets/core/ui/app_icon_foreground.dart';
import 'package:budgets/features/planning/data/datasources/budget_history_datasource.dart';
import 'package:budgets/features/planning/domain/models/budget_history_model.dart';
import 'package:budgets/features/planning/domain/providers/budget_history_provider.dart';
import 'package:budgets/core/currency/currency_provider.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/core/ui/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

part 'budget_history_states.dart';
part 'budget_history_items.dart';

class BudgetHistoryCard extends ConsumerWidget {
  final DateTime date;

  const BudgetHistoryCard({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodMonth = getPeriodMonthString(date);
    final historyAsync = ref.watch(budgetHistoryForMonthProvider(periodMonth));
    final currencyState = ref.watch(currencyControllerProvider).value;
    final currencyCode = currencyState?.code ?? 'MGA';
    final rate = currencyState?.rateFor(currencyCode) ?? 1.0;

    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final surfaceColor = Theme.of(context).colorScheme.surface;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Budgets du mois',
            style: AppTextStyle(AppTextRole.body,
                color: textColor?.withValues(alpha: 0.7)),
          ),
          SizedBox(height: 16),
          // Content
          historyAsync.when(
            data: (history) {
              if (history.isEmpty) {
                return _buildEmptyState(context, textColor);
              }
              return _buildHistoryList(
                context,
                history,
                textColor,
                isDarkMode,
                rate,
                currencyCode,
              );
            },
            loading: () => _buildLoadingSkeleton(context, isDarkMode),
            error: (error, stack) => _buildErrorState(context, textColor),
          ),
        ],
      ),
    );
  }
}
