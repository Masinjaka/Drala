part of 'envelope_page.dart';

extension _EnvelopePageActions on EnvelopePageState {
  Future<bool> _refreshFormData() async {
    try {
      await Future.wait(
          [_viewModel.refreshCategories(), _viewModel.refreshWallets()]);
      return mounted;
    } catch (error) {
      if (mounted) showErrorToast(context, error);
      return false;
    }
  }

  Future<void> _showAddSheet() async {
    if (!await _refreshFormData() || !mounted) return;
    String? walletId = _viewModel.wallets
            .where((wallet) => wallet.isDefault)
            .firstOrNull
            ?.id ??
        _viewModel.wallets.firstOrNull?.id;
    await AddEnvelopeSheet.show(
      context,
      categories: _viewModel.availableCategories,
      month: _viewModel.month,
      fundingField: EnvelopeWalletField(
        wallets: _viewModel.wallets,
        currencyState: widget.displayCurrency,
        onChanged: (value) => walletId = value,
      ),
      onSave: (name, categoryId, amount, repeatsMonthly) => _addEnvelope(
          name, categoryId, amount, repeatsMonthly,
          walletId: walletId),
      currencyState: widget.displayCurrency,
    );
  }

  Future<void> _addEnvelope(
    String name,
    String categoryId,
    int amount,
    bool repeatsMonthly, {
    String? walletId,
  }) async {
    try {
      await _viewModel.add(
        name: name,
        categoryId: categoryId,
        amount: amount,
        repeatsMonthly: repeatsMonthly,
        walletId: walletId,
      );
    } on WalletSelectionRequiredException catch (error) {
      if (!mounted) rethrow;
      await _viewModel.refreshWallets();
      if (!mounted) rethrow;
      final walletId = await WalletSourceSheet.show(
        context,
        wallets: _viewModel.wallets,
        requiredAmount: error.requiredAmount,
        currencyState: widget.displayCurrency,
        onManageWallets: widget.onManageWallets == null
            ? null
            : () async {
                await widget.onManageWallets!();
                await _load();
              },
      );
      if (walletId == null) throw const EnvelopeSaveCancelled();
      await _viewModel.add(
        name: name,
        categoryId: categoryId,
        amount: amount,
        repeatsMonthly: repeatsMonthly,
        walletId: walletId,
      );
    }
  }

  Future<void> _editEnvelope(Envelope envelope) async {
    if (!await _refreshFormData() || !mounted) return;
    await AddEnvelopeSheet.show(
      context,
      categories: _viewModel.categoriesForEditing(envelope),
      month: _viewModel.month,
      envelope: envelope,
      fundingField: EnvelopeWalletField(
        wallets: _viewModel.wallets,
        currencyState: widget.displayCurrency,
        initialWalletId: envelope.fundingWalletId,
        readOnly: true,
      ),
      currencyState: widget.displayCurrency,
      onDelete: () => _viewModel.delete(envelope.id),
      onSave: (name, categoryId, amount, repeatsMonthly) => _viewModel.update(
          id: envelope.id,
          name: name,
          categoryId: categoryId,
          amount: amount,
          repeatsMonthly: repeatsMonthly),
    );
  }
}
