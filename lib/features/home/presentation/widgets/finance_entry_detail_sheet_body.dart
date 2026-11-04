part of 'finance_entry_detail_sheet.dart';

extension _FinanceEntryDetailBody on _FinanceEntryDetailSheetState {
  Widget _buildSheet(BuildContext context) {
    final available = _categories
        .where((category) => category.transactionType == _type)
        .toList();
    final selected = _category;
    if (selected != null &&
        !available.any((category) => category.id == selected.id)) {
      available.insert(0, selected);
    }
    return TransactionSheetSurface(
      referenceStyle: true,
      pageController: _pageController,
      pages: [
        TransactionDetailEditPage(
          formKey: _formKey,
          walletField: widget.wallets.isEmpty
              ? null
              : TransferWalletField(
                  label: _type == TransactionType.income
                      ? context.l10n.toWallet
                      : context.l10n.fromWallet,
                  wallets: widget.wallets,
                  value: _sourceWalletId ??
                      widget.wallets
                          .where((wallet) => wallet.isDefault)
                          .firstOrNull
                          ?.id,
                  requiredSelection: false,
                  currencyState: widget.currencyState,
                  onChanged: (value) => _update(() {
                        _sourceWalletId = value;
                        _useAllWallets = false;
                      })),
          amountController: _amountController,
          titleController: _titleController,
          descriptionController: _descriptionController,
          currencyCode: widget.currencyState?.code ?? widget.entry.currencyCode,
          type: _type,
          category: _category,
          saving: false,
          onTypeChanged: _changeType,
          onCategoryTap: () => _goToPage(1),
          onCategoryClear: () => _update(() => _category = null),
          onClose: () => Navigator.pop(context),
          onDelete: () => Navigator.pop(
            context,
            const ManualEntrySheetResult.delete(),
          ),
          onSave: _submit,
        ),
        TransactionCategoryPage(
          categories: available,
          selected: _category,
          onSelected: (value) => _update(() => _category = value),
          onBack: () => _goToPage(0),
          onCreate: _createCategory,
        ),
      ],
    );
  }
}
