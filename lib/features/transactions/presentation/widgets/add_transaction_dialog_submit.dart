part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateSubmit on _AddTransactionDialogState {
  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _update(() => _isLoading = true);
    final result = await _module.submitTransaction(
      formKey: _formKey,
      selectedCategory: _selectedCategory,
      isMultipleAmounts: _isPerSubcategory,
      subcategoryAmounts: _subcategoryAmounts,
      montantController: _montantController,
      descriptionController: _descriptionController,
      transactionType: widget.transactionType,
      ref: ref,
    );
    if (!mounted) return;
    _update(() => _isLoading = false);
    showAppToast(context, result.message,
        type: result.success ? AppToastType.success : AppToastType.error);
    if (result.success) Navigator.of(context).pop(true);
  }
}
