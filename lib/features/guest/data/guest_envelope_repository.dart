import 'package:budgets/features/envelopes/domain/models/envelope.dart';
import 'package:budgets/features/envelopes/domain/models/envelope_category.dart';
import 'package:budgets/features/envelopes/domain/repositories/envelope_repository.dart';
import 'package:budgets/features/guest/data/guest_envelope_mutations.dart';
import 'package:budgets/features/guest/data/guest_envelope_queries.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';
import 'package:budgets/features/home/domain/models/wallet_summary.dart';

class GuestEnvelopeRepository implements EnvelopeRepository {
  const GuestEnvelopeRepository(this.queries, this.mutations, this.walletStore);

  final GuestEnvelopeQueries queries;
  final GuestEnvelopeMutations mutations;
  final GuestWalletStore walletStore;

  @override
  Future<List<Envelope>> envelopesForMonth(DateTime month) =>
      queries.envelopesForMonth(month);

  @override
  Future<List<EnvelopeCategory>> expenseCategories() =>
      queries.expenseCategories();

  @override
  Future<List<WalletSummary>> wallets() => walletStore.wallets();

  @override
  Future<void> addEnvelope({
    required String name,
    required String categoryId,
    required int amount,
    required DateTime month,
    String? walletId,
    bool repeatsMonthly = false,
  }) =>
      mutations.add(
        name: name,
        categoryId: categoryId,
        amount: amount,
        month: month,
        walletId: walletId,
        repeatsMonthly: repeatsMonthly,
      );

  @override
  Future<void> updateEnvelope({
    required String id,
    required String name,
    required String categoryId,
    required int amount,
    required bool repeatsMonthly,
  }) =>
      mutations.update(
        id: id,
        name: name,
        categoryId: categoryId,
        amount: amount,
        repeatsMonthly: repeatsMonthly,
      );

  @override
  Future<void> deleteEnvelope(String id) => mutations.delete(id);
}
