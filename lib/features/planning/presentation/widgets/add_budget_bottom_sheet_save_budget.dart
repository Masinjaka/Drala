part of 'add_budget_bottom_sheet.dart';

extension _AddBudgetBottomSheetStateSaveBudget on _AddBudgetBottomSheetState {
  Future<void> _saveBudget() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    _update(() => _isLoading = true);

    try {
      final currencyState = await ref.read(currencyControllerProvider.future);
      final rate = currencyState.rateFor(currencyState.code);
      final displayAmount = parseAmountInput(_amountController.text);
      final mgaAmount = convertToMga(displayAmount, rate).round();

      final budget = Budget(
        id: widget.budget?.id,
        category: Category(id: _selectedCategoryId),
        amount: mgaAmount.toString(),
        amountSpent: widget.budget?.amountSpent ?? '0',
        period: _selectedPeriod,
      );

      if (_isEditing) {
        await ref.read(budgetsProvider.notifier).updateSomeBudget(budget);
      } else {
        await ref.read(budgetsProvider.notifier).addSomeBudget(budget);
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        showErrorToast(context, e);
      }
    } finally {
      if (mounted) {
        _update(() => _isLoading = false);
      }
    }
  }
}
