part of 'add_category_page.dart';

extension _AddCategorySavingsInfo on _AddCategoryPageState {
  /// Build info screen for savings category that cannot be edited
  Widget _buildSavingsCategoryInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SizedBox(height: 112),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: CategoryIcon(
                      iconKey: widget.category?.iconKey,
                      emoji: widget.category?.emoji ??
                          SystemCategories.savingsCategoryEmoji,
                      colorHex: widget.category?.color ??
                          SystemCategories.savingsCategoryColor,
                      size: 30),
                ),
                SizedBox(height: 16),
                Text(
                  widget.category?.name ?? SystemCategories.savingsCategoryName,
                  style: AppTextStyle(AppTextRole.sheetTitle,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppIconForeground.resolve(
                            context, Theme.of(context).primaryColor),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Cette catégorie est utilisée automatiquement pour vos contributions aux objectifs d\'épargne. Elle ne peut pas être modifiée ou supprimée tant que vous avez des objectifs.',
                          style: AppTextStyle(AppTextRole.body,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
