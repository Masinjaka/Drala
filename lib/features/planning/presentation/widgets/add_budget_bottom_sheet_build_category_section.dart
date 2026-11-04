part of 'add_budget_bottom_sheet.dart';

extension _AddBudgetBottomSheetStateBuildCategorySection
    on _AddBudgetBottomSheetState {
  Widget _buildCategorySection() {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catégorie',
          textAlign: TextAlign.left,
          style: AppTextStyle(AppTextRole.body),
        ),
        SizedBox(height: 8),
        categoriesAsync.when(
          data: _buildCategoryPills,
          loading: () => const CategoryChipsSkeleton(),
          error: (e, _) => Text('Erreur: $e'),
        ),
      ],
    );
  }
}
