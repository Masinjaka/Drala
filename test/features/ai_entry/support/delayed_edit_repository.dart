import 'dart:async';

import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';

import 'fake_ai_entry_repository.dart';

class DelayedEditRepository extends FakeAiEntryRepository {
  final edit = Completer<void>();

  @override
  Future<FinanceEntry> updateFinanceEntry(
    String entryId,
    ManualEntryInput input,
  ) async {
    await edit.future;
    return super.updateFinanceEntry(entryId, input);
  }
}
