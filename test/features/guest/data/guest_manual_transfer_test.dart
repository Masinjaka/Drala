import 'package:budgets/features/ai_entry/domain/models/manual_transfer_input.dart';
import 'package:budgets/features/ai_entry/presentation/view_models/ai_entry_view_model.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_repositories.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GuestDatabase database;
  late GuestRepositories repositories;
  late String cash;
  late String bank;
  final date = DateTime(2026, 10, 22, 12);
  setUp(() async {
    database = GuestDatabase(NativeDatabase.memory());
    repositories = GuestRepositories(database, 'guest');
    cash = (await repositories.wallets
            .add(const AddWalletInput(name: 'Cash', initialBalance: 1000)))
        .id;
    bank = (await repositories.wallets
            .add(const AddWalletInput(name: 'Bank', initialBalance: 0)))
        .id;
  });
  tearDown(() => database.close());

  test(
      'transfer refreshes activity and balances without changing income or expense',
      () async {
    final viewModel = AiEntryViewModel(repositories.finance, date);
    addTearDown(viewModel.dispose);
    await viewModel.loadDate(date);
    expect(viewModel.supportsManualTransfers, isTrue);
    final input = ManualTransferInput(
        id: 'transfer',
        fromWalletId: cash,
        toWalletId: bank,
        amount: 200,
        occurredAt: date);
    await viewModel.addManualTransfer(input);
    expect(viewModel.entries.single.isTransfer, isTrue);
    expect(viewModel.monthlyIncome, 0);
    expect(viewModel.monthlyExpenses, 0);
    expect(viewModel.totalWalletBalance, 1000);
    expect(viewModel.wallets.firstWhere((w) => w.id == cash).balance, 800);
    expect(viewModel.wallets.firstWhere((w) => w.id == bank).balance, 200);
    expect((await repositories.entries.entriesForDate(date)).single.isTransfer,
        isTrue);
    await viewModel.addManualTransfer(input);
    expect(viewModel.entries, hasLength(1));
    expect(viewModel.wallets.firstWhere((w) => w.id == cash).balance, 800);
    final journal = await database
        .customSelect(
            "SELECT * FROM guest_sync_records WHERE table_name='wallet_transfers'")
        .get();
    expect(journal, hasLength(1));
  });

  test(
      'insufficient, same-wallet, foreign-wallet and changed retry leave balances intact',
      () async {
    final other = GuestRepositories(database, 'other');
    final foreign = (await other.wallets
            .add(const AddWalletInput(name: 'Other', initialBalance: 0)))
        .id;
    for (final ids in [
      (cash, bank, 1001),
      (cash, cash, 100),
      (cash, foreign, 100)
    ]) {
      await expectLater(
          repositories.finance.addManualTransfer(ManualTransferInput(
              id: 'bad',
              fromWalletId: ids.$1,
              toWalletId: ids.$2,
              amount: ids.$3,
              occurredAt: date)),
          throwsStateError);
    }
    expect(await repositories.wallets.totalFunds(), 1000);
    expect(await repositories.entries.entriesForDate(date), isEmpty);
    await repositories.finance.addManualTransfer(ManualTransferInput(
        id: 'once',
        fromWalletId: cash,
        toWalletId: bank,
        amount: 100,
        occurredAt: date));
    await expectLater(
        repositories.finance.addManualTransfer(ManualTransferInput(
            id: 'once',
            fromWalletId: cash,
            toWalletId: bank,
            amount: 200,
            occurredAt: date)),
        throwsStateError);
    expect(
        (await repositories.wallets.wallets())
            .firstWhere((w) => w.id == cash)
            .balance,
        900);
  });
}
