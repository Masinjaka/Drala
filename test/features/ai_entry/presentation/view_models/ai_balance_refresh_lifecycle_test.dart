import 'dart:async';
import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/delayed_balance_repository.dart';

void main() {
  const result = AiEntryResult(
      entries: [],
      message: 'Committed.',
      remaining: 19,
      provider: 'test',
      model: 'test',
      billingTier: 'free');
  const oldWallet = WalletSummary(
      id: 'cash',
      name: 'Cash',
      balance: 900,
      currencyCode: 'MGA',
      iconKey: 'wallet',
      isDefault: true);

  test('account data deletion invalidates an older pending AI balance refresh',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = result;
    final model = AiEntryViewModel(repository, DateTime(2026, 10, 23));
    addTearDown(model.dispose);
    await model.submit('A text request');
    repository.pendingWallets = null;
    await model.resetAfterDataDeletion();
    pending.complete([oldWallet]);
    await Future<void>.delayed(Duration.zero);
    expect(model.wallets, isEmpty);
    expect(model.totalWalletBalance, 0);
  });

  test(
      'a later wallet mutation invalidates an older pending AI balance refresh',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = result;
    final model = AiEntryViewModel(repository, DateTime(2026, 10, 23));
    addTearDown(model.dispose);
    await model.submit('A text request');
    await model.addWallet(
        const AddWalletInput(name: 'New wallet', initialBalance: 700));
    pending.complete([oldWallet]);
    await Future<void>.delayed(Duration.zero);
    expect(model.wallets.single.name, 'New wallet');
    expect(model.totalWalletBalance, 700);
  });
}
