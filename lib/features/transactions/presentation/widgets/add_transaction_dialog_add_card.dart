part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateAddCard on _AddTransactionDialogState {
  void _addCard() {
    if (_selectedCategory == null) {
      _formKey.currentState?.validate();
      return;
    }
    final idx = _subcategoryAmounts.length;
    _subcategoryAmounts.add(_module.createSubcategoryAmountItem());
    _update(() => _newlyAddedIndex = idx);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _update(() => _newlyAddedIndex = null);
    });
  }
}
