import 'package:budgets/core/widgets/empty_state_phrase.dart';
import 'package:budgets/core/widgets/empty_state_action.dart';
import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/material.dart';
import 'add_transaction_dialog.dart';

class IncomeEmptyState extends StatelessWidget {
  const IncomeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    void create() {
      AddTransactionDialog.show(context,
          transactionType: TransactionType.income);
    }

    return EmptyStatePhrase(
      title: context.l10n.emptyIncomes,
      brief: true,
      action:
          EmptyStateAction(label: context.l10n.createIncome, onPressed: create),
    );
  }
}
