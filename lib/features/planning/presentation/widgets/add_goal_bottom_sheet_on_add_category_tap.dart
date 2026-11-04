part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateOnAddCategoryTap on _AddGoalBottomSheetState {
  Future<void> _onAddCategoryTap() async {
    final newCategory = await AddCategoryDialog.show(
      context,
      transactionType: TransactionType.expense,
    );

    if (newCategory == null || !mounted) return;

    final updatedCategories = await ref.read(categoriesProvider.future);
    Category? createdCategory;

    for (final category in updatedCategories) {
      if (category.name == newCategory.name) {
        createdCategory = category;
        break;
      }
    }

    if (createdCategory != null) {
      _update(() {
        _selectedCategoryId = createdCategory!.id;
      });
    }
  }
}
