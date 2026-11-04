part of 'add_transaction_dialog.dart';

extension _AddTransactionDialogStateOnSubcategoryTap
    on _AddTransactionDialogState {
  Future<void> _onSubcategoryTap(Map<String, dynamic> item, int index) async {
    if (_selectedCategory == null) {
      _formKey.currentState?.validate();
      return;
    }
    final selected = await SubcategorySelectionDialog.show(context,
        subcategories: _subcategories,
        categoryId: _selectedCategory?.id,
        selectedSubcategory: item['subcategory'] as Subcategory?);
    if (selected != null && mounted) {
      _update(() {
        item['subcategory'] = selected;
        item['subcategoryName'] = selected.name ?? '';
        (item['subcategoryController'] as TextEditingController).text =
            selected.name ?? '';
        if (selected.id == null) _subcategories.add(selected);
      });
    }
  }
}
