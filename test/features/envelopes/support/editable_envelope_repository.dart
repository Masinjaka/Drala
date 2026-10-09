import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';

class EditableEnvelopeRepository implements EnvelopeRepository {
  var name = 'Food budget';
  var deleted = false;
  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) async => deleted
      ? []
      : [
          Envelope(
              id: 'food',
              name: name,
              categoryId: 'food-category',
              categoryName: 'Food',
              emoji: '🍔',
              color: 'FFFFFFFF',
              amount: 100,
              spent: 20,
              currencyCode: 'MGA')
        ];
  @override
  Future<List<EnvelopeCategory>> expenseCategories() async => const [
        EnvelopeCategory(
            id: 'food-category', name: 'Food', emoji: '🍔', color: 'FFFFFFFF')
      ];
  @override
  Future<List<WalletSummary>> wallets() async => [];
  @override
  Future<void> addEnvelope(
      {required String name,
      required String categoryId,
      required int amount,
      required DateTime month,
      String? walletId,
      bool repeatsMonthly = false}) async {}
  @override
  Future<void> updateEnvelope(
      {required String id,
      required String name,
      required String categoryId,
      required int amount,
      required bool repeatsMonthly}) async {
    this.name = name;
  }

  @override
  Future<void> deleteEnvelope(String id) async {
    deleted = true;
  }
}
