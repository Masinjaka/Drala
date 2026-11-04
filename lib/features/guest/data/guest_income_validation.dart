import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/home/domain/errors/insufficient_funds_exception.dart';
import 'package:drift/drift.dart';

class GuestIncomeValidation {
  const GuestIncomeValidation(this.database, this.userId);
  final GuestDatabase database;
  final String userId;
  Future<String?> source(String id) async {
    if (database.accountId == null) return null;
    final rows = await database.customSelect(
        "SELECT source_wallet_id FROM guest_transactions WHERE id=? AND user_id=? AND transaction_type='income'",
        variables: [
          Variable.withString(id),
          Variable.withString(userId)
        ]).get();
    return rows.isEmpty
        ? null
        : rows.single.readNullable<String>('source_wallet_id');
  }

  Future<void> check(String? walletId) async {
    if (database.accountId == null || walletId == null) return;
    final rows = await database.customSelect(
        'SELECT balance FROM guest_wallets WHERE id=? AND user_id=?',
        variables: [
          Variable.withString(walletId),
          Variable.withString(userId)
        ]).get();
    if (rows.isNotEmpty && rows.single.read<int>('balance') < 0) {
      throw InsufficientFundsException(
          requiredAmount: -rows.single.read<int>('balance'),
          availableAmount: 0);
    }
  }
}
