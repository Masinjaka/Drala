part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateClearSubcategoryAmounts
    on _AddTransactionDialogState {
  void _clearSubcategoryAmounts() {
    for (var item in _subcategoryAmounts) {
      item['subcategoryController']?.dispose();
      item['amountController']?.dispose();
    }
    _subcategoryAmounts.clear();
    _update(() {});
  }
}
