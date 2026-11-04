import 'package:budgets/features/ai_entry/domain/models/manual_transfer_input.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';

enum ManualEntrySheetAction { save, delete, transfer }

class ManualEntrySheetResult {
  const ManualEntrySheetResult.save(ManualEntryInput this.input)
      : action = ManualEntrySheetAction.save,
        transferInput = null;

  const ManualEntrySheetResult.delete()
      : action = ManualEntrySheetAction.delete,
        input = null,
        transferInput = null;

  const ManualEntrySheetResult.transfer(ManualTransferInput this.transferInput)
      : action = ManualEntrySheetAction.transfer,
        input = null;

  final ManualTransferInput? transferInput;
  final ManualEntrySheetAction action;
  final ManualEntryInput? input;
}
