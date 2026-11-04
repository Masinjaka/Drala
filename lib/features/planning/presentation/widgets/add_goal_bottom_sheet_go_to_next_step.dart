part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateGoToNextStep on _AddGoalBottomSheetState {
  Future<void> _goToNextStep() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }
}
