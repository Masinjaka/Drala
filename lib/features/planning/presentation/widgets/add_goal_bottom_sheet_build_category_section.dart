part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildCategorySection
    on _AddGoalBottomSheetState {
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
          loading: () => SizedBox(
            height: 41.6,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          error: (e, _) => Text('Erreur: $e'),
        ),
      ],
    );
  }
}
