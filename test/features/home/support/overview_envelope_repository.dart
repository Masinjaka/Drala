import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';

class OverviewEnvelopeRepository implements EnvelopeRepository {
  bool fail = false;
  int loads = 0;
  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) async {
    loads++;
    if (fail) throw StateError('offline');
    return List.generate(
        2,
        (i) => Envelope(
            id: '$i',
            name: 'Rainy days',
            categoryId: '$i',
            categoryName: 'Food',
            emoji: i == 0 ? '🌧️' : '🍽️',
            color: 'FF000000',
            amount: 300000,
            spent: 150000,
            currencyCode: 'MGA'));
  }

  @override
  Future<List<EnvelopeCategory>> expenseCategories() async => [];
  @override
  Future<List<WalletSummary>> wallets() async => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
