import 'package:budgets/core/layout/app_page_spacing.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_amount.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';

class ActivitiesSummary extends StatelessWidget {
  const ActivitiesSummary({required this.entries, this.currency, super.key});
  final List<FinanceEntry> entries;
  final CurrencyState? currency;

  @override
  Widget build(BuildContext context) {
    final net = entries.fold<num>(0, (sum, entry) {
      final amount =
          currency?.convertToSelected(entry.amount, entry.currencyCode) ??
              entry.amount;
      return sum +
          (entry.isIncome
              ? amount
              : entry.isExpense
                  ? -amount
                  : 0);
    });
    return Padding(
      padding: AppPageSpacing.insets(context, top: 24, bottom: 24),
      child: Row(children: [
        Expanded(
            child: Text(
                '${entries.length} ${context.l10n.transactions.toLowerCase()}',
                style: AppActivitiesTheme.label(context))),
        const SizedBox(width: 12),
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: HomeOverviewAmount(
                    amount: net.abs(),
                    currencyCode: currency?.code ??
                        entries.firstOrNull?.currencyCode ??
                        'MGA',
                    sign: net < 0
                        ? '- '
                        : net > 0
                            ? '+ '
                            : '',
                    style:
                        AppActivitiesTheme.net(context, positive: net >= 0)))),
      ]),
    );
  }
}
