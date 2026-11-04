part of 'goal_list_item.dart';

extension _GoalListItemStateHandleDeleteAction on _GoalListItemState {
  Future<void> _handleDeleteAction() async {
    if (_isDismissing) {
      return;
    }
    final goal = widget.goal;
    final shouldDelete = await _showDeleteDialog(context);
    if (!shouldDelete || goal.id == null) {
      await _resetSwipeFeedbackState();
      return;
    }

    await _resetSwipeFeedbackState();
    if (!mounted) {
      return;
    }

    _update(() {
      _isDismissing = true;
    });

    await Future.delayed(_GoalListItemState._dismissDuration);

    try {
      await ref.read(goalsProvider.notifier).deleteSomeGoal(goal.id!);
    } catch (e) {
      debugPrint('Error deleting goal: $e');
      if (mounted) {
        _update(() {
          _isDismissing = false;
        });
      }
    }
  }
}
