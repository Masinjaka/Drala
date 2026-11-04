import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/home/domain/models/receipt_input_result.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';
import 'package:budgets/features/receipts/domain/models/receipt_scan.dart';
import 'package:budgets/features/receipts/domain/repositories/receipt_repository.dart';

class OfflineReceiptRepository implements ReceiptRepository {
  const OfflineReceiptRepository(this.account, this.remote);
  final OfflineAccount account;
  final ReceiptRepository remote;
  @override
  Future<AiEntryResult> process(ReceiptInputResult input,
      {required DateTime targetDate, required String outputLanguage}) async {
    await account.synchronize();
    account.requireOnline();
    final result = await remote.process(input,
        targetDate: targetDate, outputLanguage: outputLanguage);
    await account.synchronize();
    return result;
  }

  @override
  Future<List<ReceiptScan>> scans() {
    account.requireOnline();
    return remote.scans();
  }

  @override
  Future<void> delete(String scanId) {
    account.requireOnline();
    return remote.delete(scanId);
  }
}
