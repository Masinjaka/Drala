import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';

class FinanceEntryEditChanges {
  const FinanceEntryEditChanges({
    this.title = false,
    this.category = false,
    this.amount = false,
  });

  factory FinanceEntryEditChanges.between(
    FinanceEntry entry,
    ManualEntryInput input,
  ) =>
      FinanceEntryEditChanges(
        title: entry.title != input.title,
        category: entry.categoryId != input.categoryId,
        amount: entry.amount != input.amount ||
            entry.transactionType != input.transactionType,
      );

  final bool title;
  final bool category;
  final bool amount;
}
