import 'dart:async';
import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/delayed_balance_repository.dart';

void main() {
  final date = DateTime(2026, 10, 23);
  AiEntryResult committed({List<WalletSummary>? wallets}) => AiEntryResult(
          entries: [
            FinanceEntry(
                id: 'expense',
                title: 'Coffee',
                categoryName: 'Food',
                amount: 100,
                occurredAt: date,
                transactionType: 'expense',
                currencyCode: 'MGA',
                iconKey: 'food',
                emoji: '☕')
          ],
          message: 'Expense added.',
          remaining: 19,
          provider: 'test',
          model: 'test',
          billingTier: 'free',
          wallets: wallets);
  WalletSummary wallet(int amount) => WalletSummary(
      id: 'cash',
      name: 'Cash',
      balance: amount,
      currencyCode: 'MGA',
      iconKey: 'wallet',
      isDefault: true);

  test(
      'a saved text expense returns without waiting for a stalled balance query',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = committed();
    final model = AiEntryViewModel(repository, date);
    addTearDown(model.dispose);
    final result = await model
        .submit('Coffee 100 Ar')
        .timeout(const Duration(milliseconds: 100));
    expect(result.entries.single.id, 'expense');
    expect(model.entries.single.id, 'expense');
    expect(model.isSubmitting, isFalse);
    expect(model.remainingRequests, 19);
    expect(model.walletsLoaded, isFalse);
    pending.complete([wallet(900)]);
    await Future<void>.delayed(Duration.zero);
    expect(model.totalWalletBalance, 900);
    expect(model.walletsLoaded, isTrue);
    expect(repository.walletReads, 1);
    expect(repository.totalReads, 0);
  });

  test(
      'a failed balance read does not turn a committed expense into a failed save',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = committed();
    final model = AiEntryViewModel(repository, date);
    addTearDown(model.dispose);
    await model.submit('Coffee 100 Ar');
    pending.completeError(StateError('Balance service unavailable'));
    await Future<void>.delayed(Duration.zero);
    expect(model.entries.single.id, 'expense');
    expect(model.isSubmitting, isFalse);
    expect(model.walletsLoaded, isFalse);
  });

  test('a late balance read cannot overwrite a newer committed wallet snapshot',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = committed();
    final model = AiEntryViewModel(repository, date);
    addTearDown(model.dispose);
    await model.submit('Coffee 100 Ar');
    repository.result = committed(wallets: [wallet(800)]);
    await model.submit('Another coffee 100 Ar');
    pending.complete([wallet(900)]);
    await Future<void>.delayed(Duration.zero);
    expect(model.wallets.single.balance, 800);
    expect(model.totalWalletBalance, 800);
  });

  test('an initial dashboard read cannot replace a newer AI wallet snapshot',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = committed(wallets: [wallet(800)]);
    final model = AiEntryViewModel(repository, date);
    addTearDown(model.dispose);
    final initialLoad = model.loadDate(date);
    await model.submit('Coffee 100 Ar');
    pending.complete([wallet(900)]);
    await initialLoad;
    expect(model.wallets.single.balance, 800);
    expect(model.totalWalletBalance, 800);
  });

  test('a background balance refresh is safe when the screen is disposed',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = committed();
    final model = AiEntryViewModel(repository, date);
    await model.submit('Coffee 100 Ar');
    model.dispose();
    pending.complete([wallet(900)]);
    await Future<void>.delayed(Duration.zero);
  });

  test(
      'a timed-out refresh does not apply its late result or repeat the expense',
      () async {
    final pending = Completer<List<WalletSummary>>();
    final repository = DelayedBalanceRepository()
      ..pendingWallets = pending
      ..result = committed();
    final model = AiEntryViewModel(repository, date,
        balanceRefreshTimeout: const Duration(milliseconds: 5));
    addTearDown(model.dispose);
    await model.submit('Coffee 100 Ar');
    await Future<void>.delayed(const Duration(milliseconds: 15));
    pending.complete([wallet(900)]);
    await Future<void>.delayed(Duration.zero);
    expect(model.entries, hasLength(1));
    expect(model.isSubmitting, isFalse);
    expect(model.walletsLoaded, isFalse);
    expect(repository.walletReads, 1);
  });
}
