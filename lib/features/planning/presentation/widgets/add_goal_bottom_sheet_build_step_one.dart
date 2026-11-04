part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildStepOne on _AddGoalBottomSheetState {
  Widget _buildStepOne() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNameField(),
        SizedBox(height: 16),
        _buildDatePicker(),
      ],
    ));
  }
}
