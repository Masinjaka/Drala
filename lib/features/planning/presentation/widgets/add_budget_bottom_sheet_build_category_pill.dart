part of 'add_budget_bottom_sheet.dart';

extension _AddBudgetBottomSheetStateBuildCategoryPill
    on _AddBudgetBottomSheetState {
  Widget _buildCategoryPill(Category category) {
    final isSelected = _selectedCategoryId == category.id;

    return GestureDetector(
      onTap: () {
        _update(() {
          _selectedCategoryId = category.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9.6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.inverseSurface
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoryIcon(
                iconKey: category.iconKey,
                emoji: category.emoji,
                colorHex: category.color,
                size: 18,
                backgroundColor: isSelected
                    ? Theme.of(context).colorScheme.inverseSurface
                    : Theme.of(context).colorScheme.surface),
            SizedBox(width: 6),
            Text(
              category.name ?? '',
              style: AppTextStyle(AppTextRole.body,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onInverseSurface
                      : Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }
}
