part of 'goal_list_item.dart';

extension _GoalListItemStateHandleSlideAnimation on _GoalListItemState {
  void _handleSlideAnimation() {
    final ratio = _slidableController.ratio.abs();
    final progress =
        (ratio / _GoalListItemState._deletePaneExtentRatio).clamp(0.0, 1.0);

    if ((progress - _swipeProgress).abs() > 0.005 && mounted) {
      _update(() {
        _swipeProgress = progress;
      });
    }

    if (!_hasTriggeredHalfSwipeHaptic && progress >= 0.5) {
      unawaited(_triggerHalfSwipeVibration());
      _hasTriggeredHalfSwipeHaptic = true;
      return;
    }

    if (_hasTriggeredHalfSwipeHaptic && progress < 0.2) {
      _hasTriggeredHalfSwipeHaptic = false;
    }
  }
}
