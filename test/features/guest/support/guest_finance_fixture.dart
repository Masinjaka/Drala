import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_repositories.dart';
import 'package:budgets/features/home/domain/models/add_wallet_input.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:drift/native.dart';

class GuestFinanceFixture {
  GuestFinanceFixture._(this.database, this.repositories, this.wallets);
  final GuestDatabase database;
  final GuestRepositories repositories;
  final List<WalletSummary> wallets;
  static Future<GuestFinanceFixture> open() async {
    final database = GuestDatabase(NativeDatabase.memory());
    final repositories = GuestRepositories(database, 'guest');
    for (final item in [('Cash', true), ('Bank', false), ('Savings', false)]) {
      await repositories.wallets.add(AddWalletInput(
          name: item.$1, initialBalance: 1000, setAsDefault: item.$2));
    }
    await database.customInsert('''INSERT INTO guest_categories
      (id,user_id,name,transaction_type,created_at,updated_at) VALUES
      ('food','guest','Food','expense','2026-10-01','2026-10-01'),
      ('travel','guest','Travel','expense','2026-10-01','2026-10-01')''');
    return GuestFinanceFixture._(
        database, repositories, await repositories.wallets.wallets());
  }

  Future<void> fundEnvelopes() async {
    for (final item in [('food', 'Food', 100), ('travel', 'Travel', 200)]) {
      await repositories.envelopeRepository.addEnvelope(
          name: item.$2,
          categoryId: item.$1,
          amount: item.$3,
          month: DateTime(2026, 10),
          walletId: wallets.first.id);
    }
  }
}
