part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildNameField on _AddGoalBottomSheetState {
  Widget _buildNameField() {
    return CustomTextField(
      title: Text(
        'Nom',
        style: AppTextStyle(AppTextRole.body,
            color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
      controller: _nameController,
      hint: 'Ex: Nouvelle voiture',
      validator: const <String, String>{
        'type': 'required',
        'error': 'Veuillez renseigner le nom',
      },
    );
  }
}
