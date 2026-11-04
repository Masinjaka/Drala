import 'package:budgets/features/home/presentation/view_models/home_overview_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/overview_entry_repository.dart';
import '../../support/overview_envelope_repository.dart';
import '../../support/overview_fixture.dart';

void main() {
  test('keeps current month totals separate from bounded recent history',
      () async {
    final entries = overviewEntries().monthlyEntries;
    final repository = OverviewEntryRepository()
      ..monthlyEntries = [entries.first]
      ..recent = entries.reversed.toList();
    final envelopes = OverviewEnvelopeRepository();
    final model =
        HomeOverviewViewModel(repository, envelopes, DateTime(2026, 10, 26));
    addTearDown(model.dispose);
    await Future.wait([model.load(), model.load()]);
    expect(repository.monthLoadCount, 1);
    expect(repository.recentLoads, 1);
    expect(model.monthlyEntries, [entries.first]);
    expect(model.recentEntries.map((e) => e.id), ['0', '1', '2', '3']);
    expect(model.envelopes, hasLength(2));
    expect(model.isLoading, isFalse);
    expect(model.error, isNull);
  });

  test('a failed refresh retains data and a successful retry clears the error',
      () async {
    final repository = OverviewEntryRepository()
      ..monthlyEntries = overviewEntries().monthlyEntries
      ..recent = overviewEntries().monthlyEntries;
    final model = HomeOverviewViewModel(
        repository, OverviewEnvelopeRepository(), DateTime(2026, 10));
    addTearDown(model.dispose);
    await model.load();
    repository.fail = true;
    await model.load();
    expect(model.error, isA<StateError>());
    expect(model.recentEntries, hasLength(4));
    expect(model.isLoading, isFalse);
    repository.fail = false;
    await model.load();
    expect(model.error, isNull);
  });
}
