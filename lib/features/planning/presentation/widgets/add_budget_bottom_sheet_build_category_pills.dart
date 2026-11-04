part of 'add_budget_bottom_sheet.dart';

extension _AddBudgetBottomSheetStateBuildCategoryPills
    on _AddBudgetBottomSheetState {
  Widget _buildCategoryPills(List<Category> categories) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final existingBudgetCategoryIds = budgetsAsync.asData?.value
            .where(
              (budget) =>
                  budget.category?.id != null && budget.id != widget.budget?.id,
            )
            .map((budget) => budget.category!.id!)
            .toSet() ??
        <String>{};

    final expenseCategories = categories.where((category) {
      final isExpense = category.transactionType?.value == 'expense';
      final isAlreadyBudgeted = existingBudgetCategoryIds.contains(category.id);
      return isExpense && !isAlreadyBudgeted;
    }).toList();

    return SizedBox(
      height: 41.6,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          ...expenseCategories.map(_buildCategoryPill),
          _buildAddCategoryPill(),
        ],
      ),
    );
  }
}
