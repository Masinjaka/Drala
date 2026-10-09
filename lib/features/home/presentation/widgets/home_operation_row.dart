import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/core/theme.dart';
import 'package:budgets/core/ui/privacy_text.dart';
import 'package:budgets/core/utils/amount_formatter.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_edit_changes.dart';
import 'package:budgets/features/home/presentation/widgets/home_operation_loading_field.dart';
import 'package:flutter/material.dart';

class HomeOperationRow extends StatelessWidget {
  const HomeOperationRow({
    required this.entry,
    required this.currencyState,
    required this.onTap,
    this.pendingEdit,
    super.key,
  });

  final FinanceEntry entry;
  final CurrencyState? currencyState;
  final VoidCallback onTap;
  final FinanceEntryEditChanges? pendingEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: entry.isTransfer || pendingEdit != null ? null : onTap,
      child: SizedBox(
        height: 66,
        child: Row(
          children: [
            HomeOperationLoadingField(
              key: ValueKey('operation-category-icon-${entry.id}'),
              isLoading: pendingEdit?.category ?? false,
              isCircle: true,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(entry.emoji,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeOperationLoadingField(
                    key: ValueKey('operation-title-${entry.id}'),
                    isLoading: pendingEdit?.title ?? false,
                    child: Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                  const SizedBox(height: 2),
                  HomeOperationLoadingField(
                    key: ValueKey('operation-category-${entry.id}'),
                    isLoading: pendingEdit?.category ?? false,
                    child: Text(
                      entry.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            HomeOperationLoadingField(
              key: ValueKey('operation-amount-${entry.id}'),
              isLoading: pendingEdit?.amount ?? false,
              child: Container(
                height: 18,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: _badgeColor(dark),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: PrivacyText(
                  '$_sign${formatAmountWithCurrency(
                    _amount,
                    _currencyCode,
                    preserveFraction: true,
                  )}',
                  maxLines: 1,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: dark
                        ? AppTheme.textDark
                        : AppTheme.interactiveTextColor,
                    fontWeight: FontWeight.w200,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _badgeColor(bool dark) {
    if (entry.isExpense) {
      return dark ? AppTheme.expenseBadgeDark : AppTheme.expenseBadgeLight;
    }
    if (entry.isIncome) {
      return dark ? AppTheme.incomeBadgeDark : AppTheme.incomeBadgeLight;
    }
    return dark ? AppTheme.transferBadgeDark : AppTheme.transferBadgeLight;
  }

  String get _sign => entry.isExpense ? '-' : (entry.isIncome ? '+' : '');

  String get _currencyCode => currencyState?.code ?? entry.currencyCode;

  num get _amount =>
      currencyState?.convertToSelected(entry.amount, entry.currencyCode) ??
      entry.amount;
}
