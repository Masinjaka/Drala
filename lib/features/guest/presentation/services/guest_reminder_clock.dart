import 'package:timezone/timezone.dart' as tz;

class GuestReminderClock {
  const GuestReminderClock._();

  static tz.TZDateTime next(
    tz.Location location,
    DateTime now,
    int hour,
    int minute,
  ) {
    final local = tz.TZDateTime.from(now, location);
    // Skip a nonexistent clock time during a daylight-saving transition.
    for (var day = 0; day < 3; day++) {
      final candidate = tz.TZDateTime(
        location,
        local.year,
        local.month,
        local.day + day,
        hour,
        minute,
      );
      if (candidate.hour == hour &&
          candidate.minute == minute &&
          candidate.isAfter(local)) {
        return candidate;
      }
    }
    throw ArgumentError('Invalid reminder time: $hour:$minute');
  }
}
