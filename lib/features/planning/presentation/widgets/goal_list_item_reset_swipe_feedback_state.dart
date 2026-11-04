part of 'goal_list_item.dart';

extension _GoalListItemStateResetSwipeFeedbackState on _GoalListItemState {
  Future<void> _resetSwipeFeedbackState() async {
    if (_hasTriggeredHalfSwipeHaptic || _swipeProgress > 0) {
      if (mounted) {
        _update(() {
          _hasTriggeredHalfSwipeHaptic = false;
          _swipeProgress = 0;
        });
      } else {
        _hasTriggeredHalfSwipeHaptic = false;
        _swipeProgress = 0;
      }
    }

    if (_slidableController.ratio != 0) {
      await _slidableController.close(duration: 120.ms);
    }
  }
}
