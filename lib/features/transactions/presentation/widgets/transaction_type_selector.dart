import 'package:budgets/core/enums/transaction_type.dart';
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
    return Container(
      height: 34,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface, width: 1.2),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(children: [
        _segment(context, TransactionType.income, incomeLabel),
        _segment(context, TransactionType.expense, expenseLabel),
      ]),
    );
  }

  Widget _segment(BuildContext context, TransactionType type, String label) {
    final selected = value == type;
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        key: ValueKey('transaction-type-${type.value}'),
        onTap: () => onChanged(type),
        borderRadius: BorderRadius.circular(5),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colors.inverseSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: selected ? colors.onInverseSurface : colors.onSurface,
                ),
          ),
        ),
      ),
    );
  }
}
