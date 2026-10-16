import 'package:budgets/core/enums/transaction_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionTypeSelector extends StatelessWidget {
  const TransactionTypeSelector({
    super.key,
    required this.value,
    required this.incomeLabel,
    required this.expenseLabel,
    required this.onChanged,
  });

  final TransactionType value;
  final String incomeLabel;
  final String expenseLabel;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: colors.onSurface,
    );
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: CupertinoSlidingSegmentedControl<TransactionType>(
        groupValue: value,
        backgroundColor: colors.surfaceContainer,
        thumbColor: colors.outline,
        onValueChanged: (type) {
          if (type != null) onChanged(type);
        },
        children: {
          TransactionType.income: Padding(
            key: const ValueKey('transaction-type-income'),
            padding: const EdgeInsets.all(5),
            child: Text(
              incomeLabel,
              textAlign: TextAlign.center,
              style: labelStyle,
            ),
          ),
          TransactionType.expense: Padding(
            key: const ValueKey('transaction-type-expense'),
            padding: const EdgeInsets.all(5),
            child: Text(
              expenseLabel,
              textAlign: TextAlign.center,
              style: labelStyle,
            ),
          ),
        },
      ),
    );
  }
}
