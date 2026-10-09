import 'package:budgets/features/stats/presentation/view_models/monthly_stats_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/deferred_stats_repository.dart';

void main() {
  test(
      'preloads adjacent months, deduplicates reads and preserves selected data',
      () async {
    final repository = DeferredStatsRepository();
    final model = MonthlyStatsViewModel(repository, DateTime(2025, 6));
    final initial = model.load();
    final duplicate = model.load();
    expect(repository.calls,
        [DateTime(2025, 5), DateTime(2025, 6), DateTime(2025, 7)]);
    final next = model.selectMonth(DateTime(2025, 7));
    repository.requests[DateTime(2025, 7)]!
        .complete(repository.value(DateTime(2025, 7)));
    await Future<void>.delayed(Duration.zero);
    expect(model.stats!.income, 7000);
    repository.completeAll();
    await Future.wait([initial, duplicate, next]);
    expect(model.month, DateTime(2025, 7));
    expect(model.stats!.income, 7000);
    expect(model.statsForMonth(DateTime(2025, 5)), isNull);
    expect(model.isLoading, isFalse);
    model.dispose();
  });
  test('late completion after page disposal is safe', () async {
    final repository = DeferredStatsRepository();
    final model = MonthlyStatsViewModel(repository, DateTime(2025, 6));
    final pending = model.load();
    model.dispose();
    repository.completeAll();
    await pending;
  });
}
