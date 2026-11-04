import 'package:budgets/core/ui/app_text_style.dart';
import 'package:budgets/core/ui/app_text_role.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManualEntrySheetHeader extends StatelessWidget {
  const ManualEntrySheetHeader({
    required this.date,
    required this.isEditing,
    super.key,
  });

  final DateTime date;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditing ? 'Edit entry' : 'Add an entry',
          style: const AppTextStyle(AppTextRole.sheetTitle),
        ),
        const SizedBox(height: 3),
        Text(
          DateFormat('EEEE, d MMMM').format(date),
          style: AppTextStyle(AppTextRole.supporting,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
