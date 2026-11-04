part of 'add_budget_bottom_sheet.dart';

extension _AddBudgetBottomSheetStateBuild on _AddBudgetBottomSheetState {
  Widget _buildFormContent(BuildContext context) {
    return Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AppSheetSurface(
            heightFactor: .86,
            keyboardAware: true,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSheetHeader(
                        title: _isEditing
                            ? 'Modifier le budget'
                            : 'Nouveau budget',
                        onClose: () => Navigator.of(context).pop(false)),
                    SizedBox(height: 16),
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
                        value: _selectedCategoryId,
                        child: _buildCategorySection()),
                    SizedBox(height: 16),
                    _buildPeriodDropdown(),
                    SizedBox(height: 24),
                    CustomButton(
                      backgroundColor: AppFinanceSurfaceTheme.action(context),
                      foregroundColor: AppFinanceSurfaceTheme.onAction(context),
                      text: _isEditing ? 'Modifier' : 'Ajouter',
                      onPressed: _saveBudget,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
