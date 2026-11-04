import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_transfer_input.dart';

abstract interface class ManualTransferRepository {
  Future<FinanceEntry> addManualTransfer(ManualTransferInput input);
}
