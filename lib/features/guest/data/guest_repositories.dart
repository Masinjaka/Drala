import 'package:budgets/features/guest/data/guest_ai_entry_repository.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_entry_mutations.dart';
import 'package:budgets/features/guest/data/guest_entry_queries.dart';
import 'package:budgets/features/guest/data/guest_envelope_mutations.dart';
import 'package:budgets/features/guest/data/guest_envelope_queries.dart';
import 'package:budgets/features/guest/data/guest_envelope_repository.dart';
import 'package:budgets/features/guest/data/guest_monthly_stats_repository.dart';
import 'package:budgets/features/guest/data/guest_wallet_store.dart';

class GuestRepositories {
  GuestRepositories(GuestDatabase database, String userId)
      : wallets = GuestWalletStore(database, userId),
        entries = GuestEntryQueries(database, userId),
        mutations = GuestEntryMutations(database, userId),
        envelopes = GuestEnvelopeQueries(database, userId),
        envelopeMutations = GuestEnvelopeMutations(database, userId);

  final GuestWalletStore wallets;
  final GuestEntryQueries entries;
  final GuestEntryMutations mutations;
  final GuestEnvelopeQueries envelopes;
  final GuestEnvelopeMutations envelopeMutations;

  GuestAiEntryRepository get finance =>
      GuestAiEntryRepository(entries, mutations, wallets);

  GuestEnvelopeRepository get envelopeRepository =>
      GuestEnvelopeRepository(envelopes, envelopeMutations, wallets);

  GuestMonthlyStatsRepository get stats => GuestMonthlyStatsRepository(entries);
}
