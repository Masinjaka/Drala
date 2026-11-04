part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateSelectDate on _AddGoalBottomSheetState {
  Future<void> _selectDate() async {
    final picked = await AppWheelPicker.date(
      context,
      initialDate: _targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      title: 'Select a target date',
    );

    if (picked == null || !mounted) return;
    _update(() {
      _targetDate = picked;
      _dateController.text = DateFormat('dd/MM/yyyy', 'fr_FR').format(picked);
    });
  }
}
