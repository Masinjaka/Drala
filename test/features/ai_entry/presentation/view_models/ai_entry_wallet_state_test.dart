import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/fake_ai_entry_repository.dart';

void main() {
  test('refreshes wallet balances after an AI transfer', () async {
    final repository = FakeAiEntryRepository()
      ..walletItems = [
        _wallet('cash', 'Cash', 400000),
        _wallet('bank', 'Bank', 600000),
      ]
      ..result = AiEntryResult(
        entries: [_transferEntry()],
        message: 'Transferred.',
        remaining: 19,
        provider: 'gemini',
        model: 'gemini-2.5-flash-lite',
        billingTier: 'free',
      );
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));
    await viewModel.loadDate(DateTime(2026, 7, 17));
    expect(viewModel.totalWalletBalance, 1000000);

    repository.walletItems = [
      _wallet('cash', 'Cash', 300000),
      _wallet('bank', 'Bank', 700000),
    ];
    await viewModel.submit('Move 100000 Ar from Cash to Bank');
    await Future<void>.delayed(Duration.zero);

    expect(viewModel.entries.single.isTransfer, isTrue);
    expect(viewModel.wallets.first.balance, 300000);
    expect(viewModel.wallets.last.balance, 700000);
    expect(viewModel.totalWalletBalance, 1000000);
  });

  test('clears entries and keeps only an empty default wallet after deletion',
      () async {
    final repository = FakeAiEntryRepository()
      ..entries = [_entry('Old expense')]
      ..walletItems = [
        _wallet('cash', 'Cash', 400000),
        _wallet('bank', 'Bank', 600000),
      ];
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));
    await viewModel.loadDate(DateTime(2026, 7, 17));
    repository.walletItems = [_wallet('cash', 'Cash', 0)];

    await viewModel.resetAfterDataDeletion();

    expect(viewModel.entries, isEmpty);
    expect(viewModel.wallets, hasLength(1));
    expect(viewModel.wallets.single.isDefault, isTrue);
    expect(viewModel.wallets.single.balance, 0);
    expect(viewModel.totalWalletBalance, 0);
    expect(viewModel.remainingRequests, 20);
  });
}

FinanceEntry _entry(String title) => FinanceEntry(
      id: title,
      title: title,
      categoryName: 'Foods & Drinks',
      amount: 24000,
      occurredAt: DateTime(2026, 7, 17),
      transactionType: 'expense',
      currencyCode: 'MGA',
      iconKey: 'food',
      emoji: '🍔',
    );

FinanceEntry _transferEntry() => FinanceEntry(
      id: 'transfer',
      title: 'Moved from Cash to Bank',
      categoryName: 'Transfer',
      amount: 100000,
      occurredAt: DateTime(2026, 7, 17),
      transactionType: 'transfer',
      currencyCode: 'MGA',
      iconKey: 'transfer',
      emoji: '↔',
      entryType: 'transfer',
    );

WalletSummary _wallet(String id, String name, int balance) => WalletSummary(
      id: id,
      name: name,
      balance: balance,
      currencyCode: 'MGA',
      iconKey: 'wallet',
      isDefault: id == 'cash',
    );
