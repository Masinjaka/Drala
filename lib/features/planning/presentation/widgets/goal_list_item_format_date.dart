part of 'goal_list_item.dart';

extension _GoalListItemStateFormatDate on _GoalListItemState {
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
