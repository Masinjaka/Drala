part of 'add_budget_bottom_sheet.dart';

extension _AddBudgetBottomSheetStateBuildPeriodDropdown
    on _AddBudgetBottomSheetState {
  Widget _buildPeriodDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Période du budget',
          style: AppTextStyle(AppTextRole.body,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedPeriod,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12.8,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Theme.of(context).cardColor,
          iconEnabledColor: Theme.of(context).hintColor,
          style: AppTextStyle(AppTextRole.body,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          items: _AddBudgetBottomSheetState._periodLabels.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            _update(() {
              _selectedPeriod = value;
            });
          },
        ),
      ],
    );
  }
}
