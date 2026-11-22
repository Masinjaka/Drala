import 'package:budgets/features/home/presentation/widgets/tab_refresh_scheduler.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const delay = Duration(milliseconds: 240);

  test('runs the refresh only after the transition', () {
    fakeAsync((async) {
      final scheduler = TabRefreshScheduler();
      var runs = 0;
      scheduler.schedule(delay, () => runs++);
      async.elapse(const Duration(milliseconds: 200));
      expect(runs, 0);
      async.elapse(const Duration(milliseconds: 40));
      expect(runs, 1);
    });
  });

  test('a quick second tab tap replaces the pending refresh', () {
    fakeAsync((async) {
      final scheduler = TabRefreshScheduler();
      final ran = <String>[];
      scheduler.schedule(delay, () => ran.add('activities'));
      async.elapse(const Duration(milliseconds: 100));
      scheduler.schedule(delay, () => ran.add('home'));
      async.elapse(delay);
      expect(ran, ['home']);
    });
  });

  test('refreshes immediately when animations are disabled', () {
    var runs = 0;
    TabRefreshScheduler().schedule(Duration.zero, () => runs++);
    expect(runs, 1);
  });

  test('dispose cancels a pending refresh', () {
    fakeAsync((async) {
      final scheduler = TabRefreshScheduler();
      var runs = 0;
      scheduler.schedule(delay, () => runs++);
      scheduler.dispose();
      async.elapse(delay * 2);
      expect(runs, 0);
    });
  });
}
