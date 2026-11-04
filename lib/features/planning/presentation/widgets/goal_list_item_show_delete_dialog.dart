part of 'goal_list_item.dart';

extension _GoalListItemStateShowDeleteDialog on _GoalListItemState {
  Future<bool> _showDeleteDialog(BuildContext context) {
    return showDeleteConfirmationDialog(
      context: context,
      title: context.l10n.deleteGoalQuestion,
      message: context.l10n.deleteGoalDescription,
    );
  }
}
