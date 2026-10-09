import 'package:budgets/core/currency/currency_state.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/widgets/finance_entry_item.dart';
import 'package:flutter/material.dart';

class FinanceEntryListTransition extends StatelessWidget {
  const FinanceEntryListTransition({
    required this.entry,
    required this.animation,
    required this.entering,
    required this.reduceMotion,
    this.onEntryTap,
    this.currencyState,
    super.key,
  });

  final FinanceEntry entry;
  final Animation<double> animation;
  final bool entering;
  final bool reduceMotion;
  final ValueChanged<FinanceEntry>? onEntryTap;
  final CurrencyState? currencyState;

  @override
  Widget build(BuildContext context) {
    final item = FinanceEntryItem(
      key: ValueKey('finance-entry-${entry.id}'),
      entry: entry,
      currencyState: currencyState,
      onTap: entering && !entry.isTransfer && onEntryTap != null
          ? () => onEntryTap!(entry)
          : null,
    );
    if (reduceMotion) return item;
    final progress = animation.drive(CurveTween(
      curve: entering ? Curves.easeOutCubic : Curves.easeInCubic,
    ));
    return SizeTransition(
      sizeFactor: progress,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: progress,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.08),
            end: Offset.zero,
          ).animate(progress),
          child: item,
        ),
      ),
    );
  }
}
