import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/domain/models/ai_quota.dart';
import 'package:budgets/features/ai_entry/domain/repositories/ai_entry_repository.dart';
import 'package:budgets/features/guest/data/guest_ai_entry_repository.dart';
import 'package:budgets/features/offline/data/services/offline_account.dart';

class OfflineAiEntryRepository extends GuestAiEntryRepository {
  OfflineAiEntryRepository(this.account, this.remote)
      : super(account.local.entries, account.local.mutations,
            account.local.wallets);
  final OfflineAccount account;
  final AiEntryRepository remote;
  @override
  Future<AiQuota> aiQuota() async {
    if (account.status.name != 'online') {
      return const AiQuota(plan: 'offline', unlimited: false, remaining: 0);
    }
    return remote.aiQuota();
  }

  Future<AiEntryResult> _cloud(Future<AiEntryResult> Function() action) async {
    await account.synchronize();
    account.requireOnline();
    final result = await action();
    await account.synchronize();
    return result;
  }

  @override
  Future<AiEntryResult> processMessage(String message,
          {required DateTime targetDate, String outputLanguage = 'en'}) =>
      _cloud(() => remote.processMessage(message,
          targetDate: targetDate, outputLanguage: outputLanguage));
  @override
  Future<AiEntryResult> resumeMessage(
          {required String requestId,
          required Map<String, dynamic> extraction,
          String? walletId,
          required bool useAllWallets,
          required DateTime targetDate}) =>
      _cloud(() => remote.resumeMessage(
          requestId: requestId,
          extraction: extraction,
          walletId: walletId,
          useAllWallets: useAllWallets,
          targetDate: targetDate));
  @override
  Future<void> cancelPendingRequest(String requestId) =>
      remote.cancelPendingRequest(requestId);
}
