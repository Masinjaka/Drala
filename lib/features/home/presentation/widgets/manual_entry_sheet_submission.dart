part of 'manual_entry_sheet.dart';

extension _ManualEntrySubmission on _ManualEntrySheetState {
  void _goToPage(int page) => _pages.animateToPage(page,
      duration: const Duration(milliseconds: 420),
      curve: transactionSheetCurve);

  Future<void> _createCategory() async {
    final created = await CategoryEditorSheet.show(context, type: _type);
    if (!mounted || created == null) return;
    _update(() {
      _categories = [..._categories, created];
      _category = created;
    });
    _goToPage(0);
  }

  void _submit() {
    final amount =
        CurrencyAmountInput.toMga(_amount.text, widget.currencyState);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final now = DateTime.now();
    final date = widget.targetDate;
    Navigator.pop(
        context,
        ManualEntrySheetResult.save(ManualEntryInput(
          title: _title.text.trim(),
          description: _description.text.trim(),
          amount: amount,
          transactionType: _type.value,
          categoryId: _category?.id,
          occurredAt: widget.entry?.occurredAt ??
              DateTime(date.year, date.month, date.day, now.hour, now.minute,
                  now.second),
          sourceWalletId: _transactionWalletId ?? widget.entry?.sourceWalletId,
          useAllWallets: _transactionWalletId == null &&
              (widget.entry?.usedMultipleWallets ?? false),
        )));
  }

  void _submitTransfer() {
    if (!(_transferFormKey.currentState?.validate() ?? false)) return;
    final amount =
        CurrencyAmountInput.toMga(_amount.text, widget.currencyState);
    final source =
        widget.wallets.where((w) => w.id == _fromWalletId).firstOrNull;
    final destination =
        widget.wallets.where((w) => w.id == _toWalletId).firstOrNull;
    if (source == null ||
        destination == null ||
        source.id == destination.id ||
        amount <= 0 ||
        amount > source.balance ||
        source.currencyCode != 'MGA' ||
        destination.currencyCode != 'MGA') {
      return;
    }
    final now = DateTime.now();
    final date = widget.targetDate;
    Navigator.pop(
        context,
        ManualEntrySheetResult.transfer(ManualTransferInput(
          id: _transferId,
          fromWalletId: source.id,
          toWalletId: destination.id,
          amount: amount,
          description: _description.text.trim(),
          occurredAt: DateTime(date.year, date.month, date.day, now.hour,
              now.minute, now.second),
        )));
  }
}
