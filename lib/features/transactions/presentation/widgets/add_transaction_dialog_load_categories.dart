part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateLoadCategories
    on _AddTransactionDialogState {
  Future<void> _loadCategories() async {
    try {
      final all = await _module.fetchCategories(ref);
      if (mounted) {
        _update(() {
          _categories = all
              .where((c) => c.transactionType == widget.transactionType)
              .toList();
          _isInitializing = false;
        });
      }
    } catch (_) {
      if (mounted) _update(() => _isInitializing = false);
    }
  }
}
