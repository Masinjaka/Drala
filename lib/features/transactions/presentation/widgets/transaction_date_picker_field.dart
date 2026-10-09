import 'package:budgets/core/ui/app_wheel_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final bool isReadOnly;
  final void Function(DateTime) onDateSelected;

  const TransactionDatePickerField({
    super.key,
    required this.selectedDate,
    required this.isReadOnly,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: isReadOnly
          ? null
          : () async {
              final picked = await AppWheelPicker.date(
                context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                title: 'Select transaction date',
              );
              if (picked != null) {
                onDateSelected(picked);
              }
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date',
              style: theme.textTheme.bodyMedium,
            ),
            Row(
              children: [
                Text(
                  selectedDate != null
                      ? DateFormat.yMMMd('fr_FR').format(selectedDate!)
                      : 'Sélectionner une date',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.onSurface,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
