import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';

class FinanceEntryPage {
  const FinanceEntryPage({
    required this.entries,
    required this.transactionOffset,
    required this.transferOffset,
    required this.hasMore,
  });

  final List<FinanceEntry> entries;
  final int transactionOffset;
  final int transferOffset;
  final bool hasMore;
}
