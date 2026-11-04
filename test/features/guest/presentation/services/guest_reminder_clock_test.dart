import 'package:budgets/features/guest/presentation/services/guest_reminder_clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as data;
import 'package:timezone/timezone.dart' as tz;

void main() {
  setUpAll(data.initializeTimeZones);
  test('uses local clock and advances an elapsed reminder to tomorrow', () {
    final zone = tz.getLocation('Indian/Antananarivo');
    final next =
        GuestReminderClock.next(zone, DateTime.utc(2026, 10, 22, 8), 10, 30);
    expect(next.day, 23);
    expect(next.hour, 10);
    expect(next.minute, 30);
    expect(next.timeZoneOffset, const Duration(hours: 3));
  });
  test('skips nonexistent DST time without changing the requested clock time',
      () {
    final zone = tz.getLocation('Europe/Berlin');
    final next =
        GuestReminderClock.next(zone, DateTime.utc(2026, 3, 29), 2, 30);
    expect(next.day, 30);
    expect(next.hour, 2);
    expect(next.minute, 30);
    expect(next.timeZoneOffset, const Duration(hours: 2));
  });
}
