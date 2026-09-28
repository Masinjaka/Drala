import 'dart:async';

import 'package:budgets/features/ai_entry/domain/models/ai_entry_result.dart';
import 'package:budgets/features/ai_entry/domain/models/finance_entry.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_ai_entry_repository.dart';

void main() {
  test('loads entries for a selected calendar date', () async {
    final repository = FakeAiEntryRepository()..entries = [_entry('existing')];
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));

    await viewModel.loadDate(DateTime(2026, 7, 15, 18));

    expect(repository.requestedDate, DateTime(2026, 7, 15));
    expect(viewModel.entries.single.title, 'existing');
    expect(viewModel.remainingRequests, 20);
    expect(viewModel.isLoading, isFalse);
  });

  test('keeps current-month totals when the selected day changes', () async {
    final repository = FakeAiEntryRepository()
      ..entries = [_datedEntry('Daily expense', 50, DateTime(2026, 7, 15))]
      ..monthlyEntries = [
        _datedEntry('Salary', 500, DateTime(2026, 7, 1), income: true),
        _datedEntry('Rent', 200, DateTime(2026, 7, 2)),
        _datedEntry('Food', 50, DateTime(2026, 7, 15)),
      ];
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));

    await viewModel.loadDate(DateTime(2026, 7, 15));
    repository.entries = [
      _datedEntry('Another day', 25, DateTime(2026, 7, 16)),
    ];
    final sameMonthLoad = viewModel.loadDate(DateTime(2026, 7, 16));
    expect(viewModel.isSummaryLoading, isFalse);
    await sameMonthLoad;

    expect(repository.requestedMonth, DateTime(2026, 7));
    expect(repository.monthLoadCount, 1);
    expect(viewModel.monthlyIncome, 500);
    expect(viewModel.monthlyExpenses, 250);

    repository.monthlyEntries = [
      _datedEntry('August salary', 700, DateTime(2026, 8), income: true),
    ];
    final nextMonthLoad = viewModel.loadDate(DateTime(2026, 8));
    expect(viewModel.isSummaryLoading, isTrue);
    await nextMonthLoad;

    expect(repository.requestedMonth, DateTime(2026, 8));
    expect(repository.monthLoadCount, 2);
    expect(viewModel.monthlyIncome, 700);
    expect(viewModel.monthlyExpenses, 0);
  });

  test('inserts a submitted entry without reloading existing entries',
      () async {
    final repository = FakeAiEntryRepository()
      ..entries = [_entry('Breakfast')]
      ..result = AiEntryResult(
        entries: [_entry('Lunch')],
        message: 'Added.',
        remaining: 19,
        provider: 'gemini',
        model: 'gemini-2.5-flash-lite',
        billingTier: 'free',
      );
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));
    await viewModel.loadDate(DateTime(2026, 7, 17));

    final result = await viewModel.submit('I spent 24000 Ar on lunch');

    expect(repository.submittedMessage, 'I spent 24000 Ar on lunch');
    expect(repository.submittedDate, DateTime(2026, 7, 17));
    expect(result.remaining, 19);
    expect(viewModel.remainingRequests, 19);
    expect(viewModel.entries.map((entry) => entry.title), [
      'Lunch',
      'Breakfast',
    ]);
    expect(repository.dateLoadCount, 1);
    expect(viewModel.isSubmitting, isFalse);
  });

  test('keeps past-date entries visible while an AI entry is pending',
      () async {
    final completer = Completer<AiEntryResult>();
    final repository = FakeAiEntryRepository()
      ..entries = [_entry('Existing')]
      ..resultCompleter = completer;
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));
    await viewModel.loadDate(DateTime(2026, 7, 12));

    final submission = viewModel.submit('Lunch 24000 Ar');

    expect(repository.submittedDate, DateTime(2026, 7, 12));
    expect(repository.requestedDate, DateTime(2026, 7, 12));
    expect(viewModel.entries.single.title, 'Existing');
    expect(viewModel.isLoading, isFalse);
    expect(viewModel.isSubmitting, isTrue);

    completer.complete(AiEntryResult(
      entries: [_entry('Lunch')],
      message: 'Added.',
      remaining: 19,
      provider: 'gemini',
      model: 'gemini-2.5-flash-lite',
      billingTier: 'free',
    ));
    await submission;

    expect(viewModel.selectedDate, DateTime(2026, 7, 12));
    expect(viewModel.entries.map((entry) => entry.title), [
      'Lunch',
      'Existing',
    ]);
    expect(repository.dateLoadCount, 1);
  });

  test('does not insert a pending result after the selected date changes',
      () async {
    final completer = Completer<AiEntryResult>();
    final repository = FakeAiEntryRepository()
      ..entries = [_entry('Old date')]
      ..resultCompleter = completer;
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));
    await viewModel.loadDate(DateTime(2026, 7, 12));

    final submission = viewModel.submit('Lunch 24000 Ar');
    repository.entries = [_entry('New date')];
    await viewModel.loadDate(DateTime(2026, 7, 13));
    completer.complete(AiEntryResult(
      entries: [_entry('Lunch')],
      message: 'Added.',
      remaining: 19,
      provider: 'gemini',
      model: 'gemini-2.5-flash-lite',
      billingTier: 'free',
    ));
    await submission;

    expect(viewModel.selectedDate, DateTime(2026, 7, 13));
    expect(viewModel.entries.single.title, 'New date');
  });

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

    expect(viewModel.entries.single.isTransfer, isTrue);
    expect(viewModel.wallets.first.balance, 300000);
    expect(viewModel.wallets.last.balance, 700000);
    expect(viewModel.totalWalletBalance, 1000000);
  });

  test('resumes an AI expense with combined wallet consent', () async {
    final repository = FakeAiEntryRepository();
    final viewModel = AiEntryViewModel(repository, DateTime(2026, 7, 17));

    await viewModel.resumeMessage(
      requestId: 'request',
      extraction: const {},
      useAllWallets: true,
    );

    expect(repository.resumedWalletId, isNull);
    expect(repository.resumedWithAllWallets, isTrue);
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

FinanceEntry _datedEntry(
  String title,
  double amount,
  DateTime occurredAt, {
  bool income = false,
}) =>
    FinanceEntry(
      id: title,
      title: title,
      categoryName: 'Other',
      amount: amount,
      occurredAt: occurredAt,
      transactionType: income ? 'income' : 'expense',
      currencyCode: 'MGA',
      iconKey: 'other',
      emoji: '🧾',
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
