part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildCategoryPills
    on _AddGoalBottomSheetState {
  Widget _buildCategoryPills(List<Category> categories) {
    final expenseCategories = categories
        .where((category) => category.transactionType?.value == 'expense')
        .toList();

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
