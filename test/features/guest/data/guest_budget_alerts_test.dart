import 'package:budgets/features/ai_entry/domain/models/manual_entry_input.dart';
import 'package:budgets/features/guest/data/guest_notification_repository.dart';
import 'package:budgets/features/guest/data/guest_preference_store.dart';
import 'package:budgets/features/notifications/domain/models/notification_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/guest_finance_fixture.dart';

void main() {
  late GuestFinanceFixture fixture;
  late GuestNotificationRepository inbox;
  ManualEntryInput expense(int amount) => ManualEntryInput(
      title: 'Lunch',
      amount: amount,
      transactionType: 'expense',
      categoryId: 'food',
      occurredAt: DateTime(2026, 10, 22),
      sourceWalletId: fixture.wallets.first.id);
  setUp(() async {
    fixture = await GuestFinanceFixture.open();
    await fixture.fundEnvelopes();
    inbox = GuestNotificationRepository(fixture.database, 'guest');
  });
  tearDown(() => fixture.database.close());

  test('near, reached and overspent alert once at each threshold', () async {
    await fixture.repositories.mutations.add(expense(89));
    expect(await inbox.notifications(), isEmpty);
    final near = await fixture.repositories.mutations.add(expense(1));
    await fixture.repositories.mutations.update(near.id, expense(1));
    expect((await inbox.notifications()).single.notificationType,
        'envelope_near_limit');
    await fixture.repositories.mutations.add(expense(10));
    await fixture.repositories.mutations.add(expense(5));
    final alerts = await inbox.notifications();
    expect(
        alerts.map((a) => a.notificationType),
        unorderedEquals([
          'envelope_near_limit',
          'envelope_limit_reached',
          'envelope_overspent'
        ]));
    expect(
        alerts
            .singleWhere((a) => a.notificationType == 'envelope_overspent')
            .amount,
        5);
    expect(
        await GuestNotificationRepository(fixture.database, 'other')
            .notifications(),
        isEmpty);
    final foreign = GuestNotificationRepository(fixture.database, 'other');
    await foreign.markRead(alerts.first.id);
    expect((await inbox.notifications()).every((a) => !a.isRead), isTrue);
    await inbox.markRead(alerts.first.id);
    expect((await inbox.notifications()).where((a) => a.isRead), hasLength(1));
  });

  test('opted-out expenses keep balances correct without alerts', () async {
    await GuestPreferenceStore(fixture.database, 'guest').setNotifications(
        NotificationSettings.defaults().copyWith(warningsEnabled: false));
    await fixture.repositories.mutations.add(expense(100));
    expect(await inbox.notifications(), isEmpty);
    final envelope = (await fixture.repositories.envelopes
            .envelopesForMonth(DateTime(2026, 10)))
        .firstWhere((e) => e.categoryId == 'food');
    expect(envelope.remaining, 0);
  });

  test('alert and balance mutations roll back together if journal fails',
      () async {
    await fixture.database.customStatement('''CREATE TRIGGER reject_journal
      BEFORE INSERT ON guest_sync_records BEGIN SELECT RAISE(ABORT,'test'); END''');
    await expectLater(fixture.repositories.mutations.add(expense(95)),
        throwsA(isA<Exception>()));
    expect(await inbox.notifications(), isEmpty);
    expect(
        await fixture.repositories.entries
            .entriesForDate(DateTime(2026, 10, 22)),
        isEmpty);
    final envelopes = await fixture.repositories.envelopes
        .envelopesForMonth(DateTime(2026, 10));
    expect(envelopes.firstWhere((e) => e.categoryId == 'food').remaining, 100);
  });
}
