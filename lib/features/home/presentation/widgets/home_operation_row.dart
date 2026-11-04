import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/ui/app_activities_theme.dart';
import 'package:budgets/core/ui/app_card_surface.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/categories/presentation/widgets/category_icon.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_edit_changes.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_loading_field.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_privacy_amount.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeOperationRow extends StatelessWidget {
  const HomeOperationRow(
      {required this.entry,
      required this.currencyState,
      required this.onTap,
      this.pendingEdit,
      this.isFirst = true,
      this.isLast = true,
      super.key});
  final FinanceEntry entry;
  final CurrencyState? currencyState;
  final VoidCallback onTap;
  final FinanceEntryEditChanges? pendingEdit;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final date =
        DateFormat.MMMd(Localizations.localeOf(context).toLanguageTag())
            .format(entry.occurredAt);
    final code = currencyState?.code ?? entry.currencyCode;
    final symbol = code == 'MGA' ? 'Ar' : currencySymbolForCode(code);
    final amount =
        currencyState?.convertToSelected(entry.amount, entry.currencyCode) ??
            entry.amount;
    final sign = entry.isExpense
        ? '- '
        : entry.isIncome
            ? '+ '
            : '';
    return AppCardSurface(
      color: AppActivitiesTheme.card(context),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(isFirst ? 24 : 10),
              bottom: Radius.circular(isLast ? 24 : 10))),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: entry.isTransfer || pendingEdit != null ? null : onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              HomeOperationLoadingField(
                  key: ValueKey('operation-category-icon-${entry.id}'),
                  isLoading: pendingEdit?.category ?? false,
                  isCircle: true,
                  child: SizedBox.square(
                      dimension: 32,
                      child: CategoryIcon(
                          iconKey: entry.iconKey,
                          emoji: entry.emoji,
                          colorHex:
                              entry.isTransfer ? null : entry.categoryColor))),
              const SizedBox(width: 16),
              Expanded(
                  flex: 3,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeOperationLoadingField(
                            key: ValueKey('operation-title-${entry.id}'),
                            isLoading: pendingEdit?.title ?? false,
                            child: Text(entry.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppActivitiesTheme.label(context))),
                        const SizedBox(height: 4),
                        HomeOperationLoadingField(
                            key: ValueKey('operation-category-${entry.id}'),
                            isLoading: pendingEdit?.category ?? false,
                            child: Text('${entry.categoryName} · $date',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppActivitiesTheme.caption(context))),
                      ])),
              const SizedBox(width: 8),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: HomeOperationLoadingField(
                          key: ValueKey('operation-amount-${entry.id}'),
                          isLoading: pendingEdit?.amount ?? false,
                          child: HomeOperationPrivacyAmount(
                              id: entry.id,
                              useAmountFont: false,
                              text:
                                  '$sign$symbol ${formatAmountForInput(amount, preserveFraction: true)}',
                              style: entry.isIncome
                                  ? AppActivitiesTheme.net(context,
                                      positive: true)
                                  : AppActivitiesTheme.label(context))))),
            ]),
          ),
        ),
      ),
    );
  }
}
