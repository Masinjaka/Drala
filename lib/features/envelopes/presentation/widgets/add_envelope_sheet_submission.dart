part of 'add_envelope_sheet.dart';

extension _EnvelopeSheetSubmission on _AddEnvelopeSheetState {
  Future<void> _save() async {
    if (_saving) return;
    final existing = widget.envelope;
    final unchangedAmount = existing != null &&
        _amountController.text ==
            CurrencyAmountInput.fromStored(
                existing.amount, existing.currencyCode, widget.currencyState);
    final amount = unchangedAmount
        ? existing.amount
        : CurrencyAmountInput.toMga(
            _amountController.text,
            widget.currencyState,
          );
    final name = _nameController.text.trim();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _setSaving(true);
    try {
      await widget.onSave(name, _category!.id!, amount, _repeatsMonthly);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted && error is! EnvelopeSaveCancelled) {
        showErrorToast(context, error);
      }
    } finally {
      if (mounted) _setSaving(false);
    }
  }
}
