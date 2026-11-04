import 'package:budgets/core/ui/finance_sheet_scope.dart';
import 'package:budgets/features/transactions/presentation/widgets/reference_entry_type_selector.dart';
import 'dart:math' as math;
import 'package:budgets/l10n/app_localizations_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManualEntryTypeSelector extends StatelessWidget {
  const ManualEntryTypeSelector(
      {required this.value, required this.onChanged, super.key});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    if (FinanceSheetScope.of(context))
      return ReferenceEntryTypeSelector(
          value: value,
          labels: {
            'expense': context.l10n.expense,
            'income': context.l10n.income,
            'transfer': context.l10n.transfer
          },
          onChanged: onChanged);
    final theme = Theme.of(context);
    final fontSize = theme.textTheme.labelSmall!.fontSize!;
    final textScale =
        MediaQuery.textScalerOf(context).scale(fontSize) / fontSize;
    return SizedBox(
      width: double.infinity,
      height: 34 * math.max(1, textScale),
      child: CupertinoSlidingSegmentedControl<String>(
        groupValue: value,
        backgroundColor: theme.colorScheme.surfaceContainer,
        thumbColor: theme.colorScheme.outline,
        onValueChanged: (value) {
          if (value != null) onChanged(value);
        },
        children: {
          for (final item in {
            'income': context.l10n.income,
            'expense': context.l10n.expense,
            'transfer': context.l10n.transfer,
          }.entries)
            item.key: Padding(
              key: ValueKey('transaction-type-${item.key}'),
              padding: const EdgeInsets.all(5),
              child: Text(item.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall),
            ),
        },
      ),
    );
  }
}
