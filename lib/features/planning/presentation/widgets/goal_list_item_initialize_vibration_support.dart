part of 'goal_list_item.dart';

extension _GoalListItemStateInitializeVibrationSupport on _GoalListItemState {
  Future<void> _initializeVibrationSupport() async {
    try {
      final canVibrate = await Vibration.hasVibrator();
      _canVibrate = canVibrate == true;
    } catch (_) {
      _canVibrate = false;
    }
  }
}
