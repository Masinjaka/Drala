part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStatePickImage on _AddGoalBottomSheetState {
  Future<void> _pickImage() async {
    final file = await pickImageWithPermissions(
      context,
      description:
          'Nous avons besoin de l\'accès à vos photos pour ajouter une image à votre objectif.',
    );

    if (!mounted || file == null) return;
    _update(() => _imagePath = file.path);
  }
}
