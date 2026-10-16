import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/domain/models/ai_quota.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry_page.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_category.dart';
import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/ai_entry/domain/repositories/ai_entry_repository.dart';
import 'package:budgets/features/ai_entry/domain/repositories/paged_ai_entry_repository.dart';
import 'package:budgets/features/guest/data/guest_entry_mutations.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';

class GuestAiEntryRepository
    implements AiEntryRepository, PagedAiEntryRepository {
  const GuestAiEntryRepository(this.queries, this.mutations, this.walletStore);

  final GuestEntryQueries queries;
  final GuestEntryMutations mutations;
  final GuestWalletStore walletStore;

  @override
  Future<List<FinanceEntry>> entriesForDate(DateTime date) =>
      queries.entriesForDate(date);

  @override
  Future<List<FinanceEntry>> entriesForMonth(DateTime month) =>
      queries.entriesForMonth(month);

  @override
  Future<FinanceEntryPage> entriesForDatePage(DateTime date,
          {required int limit,
          required int transactionOffset,
          required int transferOffset}) =>
      queries.entriesForDatePage(date,
          limit: limit,
          transactionOffset: transactionOffset,
          transferOffset: transferOffset);

  @override
  Future<bool> hasAnyEntries() => queries.hasAnyEntries();

  @override
  Future<Set<DateTime>> activityDatesForMonth(DateTime month) =>
      queries.activityDatesForMonth(month);

  @override
  Future<AiQuota> aiQuota() async =>
      const AiQuota(plan: 'guest', unlimited: false, remaining: 0);

  @override
  Future<List<WalletSummary>> wallets() => walletStore.wallets();

  @override
  Future<WalletSummary> addWallet(AddWalletInput input) =>
      walletStore.add(input);

  @override
  Future<WalletSummary> updateWallet(String walletId, AddWalletInput input) =>
      walletStore.update(walletId, input);

  @override
  Future<void> deleteWallet(String walletId) => walletStore.delete(walletId);

  @override
  Future<int> totalFunds() => walletStore.totalFunds();

  @override
  Future<List<ManualEntryCategory>> manualEntryCategories() =>
      queries.categories();

  @override
  Future<FinanceEntry> addManualEntry(ManualEntryInput input) =>
      mutations.add(input);

  @override
  Future<FinanceEntry> updateFinanceEntry(
          String entryId, ManualEntryInput input) =>
      mutations.update(entryId, input);

  @override
  Future<void> deleteFinanceEntry(String entryId) => mutations.delete(entryId);

  @override
  Future<AiEntryResult> processMessage(String message,
          {required DateTime targetDate, String outputLanguage = 'en'}) =>
      Future.error(StateError('AI entry requires an account.'));

  @override
  Future<AiEntryResult> resumeMessage(
          {required String requestId,
          required Map<String, dynamic> extraction,
          String? walletId,
          required bool useAllWallets,
          required DateTime targetDate}) =>
      Future.error(StateError('AI entry requires an account.'));

  @override
  Future<void> cancelPendingRequest(String requestId) async {}
}
