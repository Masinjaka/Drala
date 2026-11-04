import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';

abstract interface class RecentTransactionRepository {
  Future<List<FinanceEntry>> recentTransactions({int limit = 3});
}
