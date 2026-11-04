part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateOnCategoryTap
    on _AddTransactionDialogState {
  Future<void> _onCategoryTap(Category category) async {
    if (category.id == _selectedCategory?.id) return;
    if (_subcategoryAmounts.isNotEmpty) _clearSubcategoryAmounts();
    _update(() {
      _selectedCategory = category;
      _subcategories = [];
    });
    if (category.id != null) {
      try {
        final subs = await _module.fetchSubcategories(ref, category.id!);
        if (mounted) _update(() => _subcategories = subs);
      } catch (_) {
        if (mounted) _update(() => _subcategories = []);
      }
    }
  }
}
