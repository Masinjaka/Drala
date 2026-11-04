part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildDatePicker on _AddGoalBottomSheetState {
  Widget _buildDatePicker() {
    return CustomTextField(
      title: Text(
        'Échéance (optionnel)',
        style: AppTextStyle(AppTextRole.body,
            color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      controller: _dateController,
      isReadOnly: true,
      onTap: _selectDate,
      hint: 'Choisir une échéance',
      suffixIcon: Icon(
        Icons.calendar_today,
        size: 18,
        color: AppIconForeground.resolve(context, Theme.of(context).hintColor),
      ),
    );
  }
}
