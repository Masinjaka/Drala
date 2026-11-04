import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/repositories/recent_transaction_repository.dart';
import '../../ai_entry/support/fake_ai_entry_repository.dart';

class OverviewEntryRepository extends FakeAiEntryRepository
    implements RecentTransactionRepository {
  List<FinanceEntry> recent = [];
  bool fail = false;
  int recentLoads = 0;
  @override
  Future<List<FinanceEntry>> recentTransactions({int limit = 3}) async {
    recentLoads++;
    if (fail) throw StateError('offline');
    return recent.take(limit).toList();
  }
}
