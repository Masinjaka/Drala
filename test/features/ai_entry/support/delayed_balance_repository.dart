import 'dart:async';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'fake_ai_entry_repository.dart';

class DelayedBalanceRepository extends FakeAiEntryRepository {
  Completer<List<WalletSummary>>? pendingWallets;
  int walletReads = 0;
  int totalReads = 0;

  @override
  Future<List<WalletSummary>> wallets() {
    walletReads++;
    return pendingWallets?.future ?? super.wallets();
  }

  @override
  Future<int> totalFunds() {
    totalReads++;
    return super.totalFunds();
  }
}
