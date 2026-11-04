part of 'goal_list_item.dart';

extension _GoalListItemStateTriggerHalfSwipeVibration on _GoalListItemState {
  Future<void> _triggerHalfSwipeVibration() async {
    if (!_canVibrate) {
      return;
    }
    try {
      await Vibration.vibrate(duration: 30);
    } catch (_) {
      // Ignore vibration failures to keep delete swipe stable.
    }
  }
}
