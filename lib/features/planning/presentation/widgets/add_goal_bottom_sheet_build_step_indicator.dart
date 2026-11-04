part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildStepIndicator
    on _AddGoalBottomSheetState {
  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(2, (index) {
        final isActive = _currentStep == index;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: EdgeInsets.only(right: index == 0 ? 7.2 : 0),
            height: 6.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isActive
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.surfaceDim,
            ),
          ),
        );
      }),
    );
  }
}
