import 'dart:async';

/// Runs a tab's data refresh once its switch animation has finished.
///
/// Refreshing straight away rebuilds the whole shell while the bottom bar is
/// still animating, which drops frames. Only the latest request runs.
class TabRefreshScheduler {
  Timer? _timer;

  void schedule(Duration delay, void Function() refresh) {
    _timer?.cancel();
    if (delay == Duration.zero) {
      _timer = null;
      refresh();
      return;
    }
    _timer = Timer(delay, refresh);
  }

  void dispose() => _timer?.cancel();
}
