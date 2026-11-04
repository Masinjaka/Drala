part of 'add_transaction.dart';

extension _TransactionCreationPageStateBuildAddButton
    on _TransactionCreationPageState {
  Widget _buildAddButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: CustomButton(
        text: isEditMode ? 'Enregistrer' : 'Confirmer',
        backgroundColor: Theme.of(context).primaryColor,
        isLoading: _isLoading,
        onPressed: () async {
          if (!(_formKey.currentState?.validate() ?? false)) return;
          _update(() => _isLoading = true);
          final result = await _module.submitTransaction(
            formKey: _formKey,
            selectedCategory: _selectedCategory,
            isMultipleAmounts: _isMultipleAmounts,
            subcategoryAmounts: _subcategoryAmounts,
            montantController: _montantController,
            descriptionController: _descriptionController,
            transactionType: transactionType,
            ref: ref,
            transactionId: widget.transaction?.id,
            transactionDate: isEditMode ? _selectedDate : null,
            originalTransaction: widget.transaction,
          );
          if (!mounted) return;
          _update(() => _isLoading = false);
          showAppToast(context, result.message,
              type: result.success ? AppToastType.success : AppToastType.error);
          if (result.success) context.pop();
        },
      ),
    );
  }
}
