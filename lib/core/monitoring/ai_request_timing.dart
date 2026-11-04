import 'package:flutter/foundation.dart';

class AiRequestTiming {
  AiRequestTiming(this.phase) : _watch = Stopwatch()..start();
  final String phase;
  final Stopwatch _watch;

  void finish({required bool succeeded}) {
    _watch.stop();
    if (kDebugMode) {
      // Timings only: never log messages, amounts, tokens, or account details.
      debugPrint('[Drala][AI latency] phase=$phase '
          'duration_ms=${_watch.elapsedMilliseconds} succeeded=$succeeded');
    }
  }
}
