import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/envelopes/presentation/view_models/envelope_view_model.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads the selected month and its adjacent months', () async {
    final now = DateTime.now();
    final selected = DateTime(now.year, now.month - 2);
    final repository = _RecordingEnvelopeRepository();
    final viewModel = EnvelopeViewModel(repository, selected);

    await viewModel.load();

    expect(repository.loadedMonths, {
      _key(DateTime(selected.year, selected.month - 1)),
      _key(selected),
      _key(DateTime(selected.year, selected.month + 1)),
    });
    expect(viewModel.envelopesForMonth(selected), isNotEmpty);
    expect(viewModel.isMonthLoading(selected), isFalse);
  });

  test('changing month keeps both adjacent pages ready', () async {
    final now = DateTime.now();
    final selected = DateTime(now.year, now.month - 2);
    final repository = _RecordingEnvelopeRepository();
    final viewModel = EnvelopeViewModel(repository, selected);
    await viewModel.load();

    await viewModel.changeMonth(-1);

    final previous = DateTime(selected.year, selected.month - 2);
    expect(repository.loadedMonths, contains(_key(previous)));
    expect(viewModel.isMonthLoading(previous), isFalse);
    expect(viewModel.isMonthLoading(selected), isFalse);
  });
}

class _RecordingEnvelopeRepository implements EnvelopeRepository {
  final loadedMonths = <String>{};

  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) async {
    loadedMonths.add(_key(month));
    return [
      Envelope(
        id: _key(month),
        name: _key(month),
        categoryId: 'food',
        categoryName: 'Food',
        emoji: '🍔',
        color: 'FFFFFFFF',
        amount: 100,
        spent: 20,
        currencyCode: 'MGA',
      ),
    ];
  }

  @override
  Future<List<EnvelopeCategory>> expenseCategories() async => const [];
  @override
  Future<List<WalletSummary>> wallets() async => const [];
  @override
  Future<void> addEnvelope({
    required String name,
    required String categoryId,
    required int amount,
    required DateTime month,
    String? walletId,
    bool repeatsMonthly = false,
  }) async {}
  @override
  Future<void> updateEnvelope(
      {required String id,
      required String name,
      required String categoryId,
      required int amount,
      required bool repeatsMonthly}) async {}

  @override
  Future<void> deleteEnvelope(String id) async {}
}

String _key(DateTime month) => '${month.year}-${month.month}';
