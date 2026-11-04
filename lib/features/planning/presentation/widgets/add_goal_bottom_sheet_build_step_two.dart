part of 'add_goal_bottom_sheet.dart';

extension _AddGoalBottomSheetStateBuildStepTwo on _AddGoalBottomSheetState {
  Widget _buildStepTwo() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValidatedInput(
              controller: _amountController,
              validator: (value) =>
                  FieldValidators.positiveAmount(context, value),
              child: AnimatedAmountField(
                controller: _amountController,
                hint: '0.00',
                fontSize: AppTypography.display,
                fillColor: Theme.of(context).colorScheme.surfaceDim,
                height: 120,
                width: double.infinity,
                borderRadius: BorderRadius.circular(12),
              )),
          SizedBox(height: 16),
          ValidatedSelection(
              value: _selectedCategoryId, child: _buildCategorySection()),
          SizedBox(height: 16),
          _buildImagePicker(),
          SizedBox(height: 6.4),
        ],
      ),
    );
  }
}
