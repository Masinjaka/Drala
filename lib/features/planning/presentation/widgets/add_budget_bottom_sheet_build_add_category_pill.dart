part of 'add_budget_bottom_sheet.dart';

extension _AddBudgetBottomSheetStateBuildAddCategoryPill
    on _AddBudgetBottomSheetState {
  Widget _buildAddCategoryPill() {
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(200);

    return GestureDetector(
      onTap: _onAddCategoryTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: 14,
              color: AppIconForeground.resolve(context, textColor),
            ),
            SizedBox(width: 4),
            Text(
              'Ajouter une catégorie',
              style: AppTextStyle(AppTextRole.body, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
