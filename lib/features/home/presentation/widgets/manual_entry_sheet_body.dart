part of 'manual_entry_sheet.dart';

extension _ManualEntryBody on _ManualEntrySheetState {
  Widget _buildSheet(BuildContext context) => TransactionSheetSurface(
        referenceStyle: true,
        pageController: _pages,
        pages: [
          Column(children: [
            ManualEntryFormHeader(
              title: widget.entry == null
                  ? context.l10n.enterManually
                  : context.l10n.editTransaction,
              selector: _typeSelector ??
                  TransactionTypeSelector(
                    value: _type,
                    incomeLabel: context.l10n.income,
                    expenseLabel: context.l10n.expense,
                    onChanged: (value) => _selectType(value.value),
                  ),
              onClose: () => Navigator.pop(context),
              onDelete: widget.entry == null
                  ? null
                  : () => Navigator.pop(
                      context, const ManualEntrySheetResult.delete()),
            ),
            Expanded(
                child: ManualEntryTypePages(
              index: _isTransfer ? 2 : _type.index,
              children: [
                for (final type in TransactionType.values)
                  _transactionPage(context, type),
                if (widget.allowTransfers && widget.entry == null)
                  ManualTransferFormPage(
                      formKey: _transferFormKey,
                      wallets: widget.wallets,
                      amount: _amount,
                      description: _description,
                      fromWalletId: _fromWalletId,
                      toWalletId: _toWalletId,
                      currencyState: widget.currencyState,
                      onSave: _submitTransfer,
                      onFromChanged: (value) => _update(() {
                            _fromWalletId = value;
                            if (_toWalletId == value) _toWalletId = null;
                          }),
                      onToChanged: (value) =>
                          _update(() => _toWalletId = value)),
              ],
            )),
          ]),
          TransactionCategoryPage(
            isLoading: _loading,
            categories: _categories
                .where((item) => item.transactionType == _type)
                .toList(),
            selected: _category,
            onSelected: (value) => _update(() => _category = value),
            onCreate: _createCategory,
            onBack: () => _goToPage(0),
          ),
        ],
      );

  Widget _transactionPage(BuildContext context, TransactionType type) =>
      TransactionDetailEditPage(
        animateEntrance: false,
        showControls: false,
        typeSelector: _typeSelector,
        walletField: widget.wallets.isEmpty
            ? null
            : TransferWalletField(
                label: type == TransactionType.income
                    ? context.l10n.toWallet
                    : context.l10n.fromWallet,
                wallets: widget.wallets,
                value: _transactionWalletId ?? _fromWalletId,
                requiredSelection: false,
                currencyState: widget.currencyState,
                onChanged: (value) =>
                    _update(() => _transactionWalletId = value)),
        heading: widget.entry == null ? context.l10n.enterManually : null,
        formKey: _formKeys[type]!,
        amountController: _amount,
        titleController: _title,
        descriptionController: _description,
        currencyCode: widget.currencyState?.code ?? 'MGA',
        type: type,
        category: type == _type ? _category : null,
        saving: false,
        onTypeChanged: (value) => _selectType(value.value),
        onCategoryTap: () => _goToPage(1),
        onCategoryClear: () => _update(() => _category = null),
        onClose: () => Navigator.pop(context),
        onDelete: widget.entry == null
            ? null
            : () =>
                Navigator.pop(context, const ManualEntrySheetResult.delete()),
        onSave: _submit,
      );

  void _selectType(String value) => _update(() {
        _isTransfer = value == 'transfer';
        if (!_isTransfer) {
          final type = TransactionType.fromValue(value)!;
          if (_type != type) _category = null;
          _type = type;
        }
      });

  Widget? get _typeSelector => !widget.allowTransfers || widget.entry != null
      ? null
      : ManualEntryTypeSelector(
          value: _isTransfer ? 'transfer' : _type.value,
          onChanged: _selectType);
}
