part of 'goal_list_item.dart';

extension _GoalListItemStateShowAddAmountForm on _GoalListItemState {
  Future<void> _showAddAmountDialog(BuildContext context, WidgetRef ref,
      double rate, String currencyCode) async {
    final goal = widget.goal;
    final formKey = GlobalKey<FormState>();
    final amountController = AmountTextEditingController();
    final currentAmountMga = parseAmountInput(goal.currentAmount ?? '0');
    final goalAmountMga = parseAmountInput(goal.goalAmount ?? '0');
    final currentAmount = convertFromMga(currentAmountMga, rate);
    final goalAmount = convertFromMga(goalAmountMga, rate);
    final result = await showAnimatedDialog<double>(
      context: context,
      builder: (ctx) => _buildTopUpForm(context, ctx, formKey, amountController,
          goal, currentAmount, goalAmount, currencyCode),
    );
    amountController.dispose();
    if (result != null) {
      final balance = await ref.read(allTimeBalanceProvider.future);
      final resultMga = convertToMga(result, rate);
      if (balance < resultMga) {
        if (context.mounted) {
          showInfoToast(context, 'Solde insuffisant pour cette opération');
        }
        return;
      }
      final currentAmountMga = parseAmountInput(goal.currentAmount ?? '0');
      final newAmount = currentAmountMga + resultMga;
      final updatedGoal = goal.copyWith(
        currentAmount: newAmount.toStringAsFixed(0),
      );
      try {
        await category_api.ensureSavingsCategoryExists();
        await ref.read(goalsProvider.notifier).updateSomeGoal(updatedGoal);
        await ref.read(transactionsProvider.notifier).addUserTransaction(
              resultMga.toStringAsFixed(0),
              'Contribution à ${goal.name}',
              SystemCategories.savingsCategoryName,
              null,
              TransactionType.expense,
            );
        if (context.mounted) {
          showSuccessToast(context, 'Montant ajouté et déduit du solde global');
        }
      } catch (e) {
        if (context.mounted) {
          showErrorToast(context, e);
        }
      }
    }
  }
}
