part of 'goal_list_item.dart';

extension _GoalListItemStateShowEditDialog on _GoalListItemState {
  void _showEditDialog(BuildContext context) {
    AddGoalBottomSheet.show(context, goal: widget.goal);
  }
}
