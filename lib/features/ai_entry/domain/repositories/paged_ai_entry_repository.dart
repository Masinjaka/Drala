import 'package:budgets/features/ai_entry/domain/models/finance_entry_page.dart';

abstract interface class PagedAiEntryRepository {
  Future<FinanceEntryPage> entriesForDatePage(
    DateTime date, {
    required int limit,
    required int transactionOffset,
    required int transferOffset,
  });
}
