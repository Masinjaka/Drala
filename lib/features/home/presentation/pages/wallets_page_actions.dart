part of 'wallets_page.dart';

extension _WalletsPageActions on _WalletsPageState {
  Set<String> get _selectableWalletIds =>
      (widget.walletReader?.call() ?? widget.wallets)
          .where((wallet) => !wallet.isDefault)
          .map((wallet) => wallet.id)
          .toSet();

  Set<String> get _selectedWalletIds =>
      _selected.intersection(_selectableWalletIds);

  void _toggleAllWallets() {
    if (_deleting) return;
    final selectable = _selectableWalletIds;
    final allSelected = selectable.every(_selected.contains);
    _update(() {
      _selected.clear();
      if (!allSelected) _selected.addAll(selectable);
    });
  }

  Future<void> _add(BuildContext context) async {
    final input =
        await AddWalletSheet.show(context, currencyState: widget.currencyState);
    if (input == null || !context.mounted) return;
    try {
      await widget.onAddWallet(input);
    } catch (error) {
      if (context.mounted) showErrorToast(context, error);
    }
  }

  Future<void> _edit(BuildContext context, WalletSummary wallet) async {
    final result = await EditWalletSheet.show(context,
        wallet: wallet, currencyState: widget.currencyState);
    if (result == null || !context.mounted) return;
    try {
      if (result.action == WalletEditorAction.delete) {
        final confirmed = await showDeleteConfirmationDialog(
          context: context,
          title: context.l10n.deleteWalletQuestion,
          message: context.l10n.deleteWalletDescription,
        );
        if (!confirmed || !context.mounted) return;
        await widget.onDeleteWallet(wallet.id);
      } else {
        await widget.onUpdateWallet(wallet.id, result.input!);
      }
    } catch (error) {
      if (context.mounted) showErrorToast(context, error);
    }
  }

  void _toggleWallet(WalletSummary wallet) {
    if (_deleting || wallet.isDefault) return;
    _update(() {
      if (!_selected.add(wallet.id)) _selected.remove(wallet.id);
    });
  }

  void _cancelSelection() => _update(() {
        _selecting = false;
        _selected.clear();
      });

  Future<void> _deleteSelected() async {
    if (_deleting ||
        _selectedWalletIds.isEmpty ||
        widget.onDeleteWallets == null) {
      return;
    }
    final ids = _selectedWalletIds.toList(growable: false);
    final confirmed = await showDeleteConfirmationDialog(
        context: context,
        title: context.l10n.deleteSelectedItems,
        message: context.l10n.deleteSelectedWalletsDescription(ids.length));
    if (!mounted || !confirmed) return;
    _update(() => _deleting = true);
    try {
      await widget.onDeleteWallets!(ids);
      if (mounted) _cancelSelection();
    } catch (error) {
      if (mounted) showErrorToast(context, error);
    } finally {
      if (mounted) _update(() => _deleting = false);
    }
  }
}
