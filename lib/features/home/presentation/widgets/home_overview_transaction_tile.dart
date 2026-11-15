import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_home_overview_theme.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_amount.dart';
import 'package:budgets/features/home/presentation/widgets/home_overview_category_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeOverviewTransactionTile extends StatelessWidget {
  const HomeOverviewTransactionTile(
      {required this.entry,
      required this.onPressed,
      this.currency,
      this.isFirst = true,
      this.isLast = true,
      super.key});
  final bool isFirst;
  final bool isLast;
  final FinanceEntry entry;
  final CurrencyState? currency;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final date =
        DateFormat.MMMd(Localizations.localeOf(context).toLanguageTag())
            .format(entry.occurredAt);
    return AppCardSurface(
      color: AppHomeOverviewTheme.surface(context),
      shape: AppHomeOverviewTheme.transactionShape(
          isFirst: isFirst, isLast: isLast),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          onTap: onPressed,
          child: ConstrainedBox(
              constraints: const BoxConstraints(
                  minHeight: AppHomeOverviewTheme.transactionMinHeight),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  SizedBox.square(
                      dimension: 32,
                      child: HomeOverviewCategoryIcon(
                          iconKey: entry.iconKey,
                          emoji: entry.emoji,
                          colorHex:
                              entry.isTransfer ? null : entry.categoryColor)),
                  const SizedBox(width: 12),
                  Expanded(
                      flex: 3,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entry.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppHomeOverviewTheme.label(context)),
                            const SizedBox(height: 4),
                            Text('${entry.categoryName} · $date',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppHomeOverviewTheme.caption(context)),
                          ])),
                  const SizedBox(width: 8),
                  Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: HomeOverviewAmount(
                            amount: currency?.convertToSelected(
                                    entry.amount, entry.currencyCode) ??
                                entry.amount,
                            currencyCode: currency?.code ?? entry.currencyCode,
                            sign: entry.isExpense
                                ? '- '
                                : entry.isIncome
                                    ? '+ '
                                    : '',
                            style: AppHomeOverviewTheme.transactionAmount(
                                context,
                                income: entry.isIncome)),
                      )),
                ]),
              ))),
    );
  }
}
