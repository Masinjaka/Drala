import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'add_transaction_dialog.dart';
export "income_empty_state.dart";

class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState(
      {required this.hasFilters, this.onReset, super.key});
  final bool hasFilters;
  final VoidCallback? onReset;
  @override
  Widget build(BuildContext context) {
    void create() {
      AddTransactionDialog.show(context,
          transactionType: TransactionType.expense);
    }

    return EmptyStatePhrase(
      title: hasFilters ? context.l10n.emptySearch : context.l10n.emptyExpenses,
      brief: true,
      action: hasFilters && onReset == null
          ? null
          : EmptyStateAction(
              label: hasFilters
                  ? context.l10n.resetSearch
                  : context.l10n.createExpense,
              onPressed: hasFilters ? onReset! : create),
    );
  }
}
