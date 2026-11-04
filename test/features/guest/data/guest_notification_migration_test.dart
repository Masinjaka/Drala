import '../support/pre_offline_schema.dart';
import 'dart:io';

import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'version 3 upgrade preserves data and adds a clearable notification inbox',
      () async {
    final directory = await Directory.systemTemp.createTemp('guest-inbox-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/guest.sqlite');
    final old = GuestDatabase(NativeDatabase(file));
    await old.customStatement(
        "INSERT INTO guest_preferences VALUES('existing','value','2026-10-22')");
    await old.customStatement('DROP TABLE guest_notifications');
    await removeOfflineSchema(old);
    await old.customStatement('PRAGMA user_version=3');
    await old.close();
    final upgraded = GuestDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);
    expect(
        (await upgraded
                .customSelect('SELECT value FROM guest_preferences')
                .getSingle())
            .read<String>('value'),
        'value');
    await upgraded.customStatement('''INSERT INTO guest_notifications
      (id,user_id,envelope_id,transaction_id,notification_type,envelope_name,amount,period_month,created_at)
      VALUES('alert','guest','food','entry','envelope_near_limit','Food',90,'2026-10-01','2026-10-22')''');
    await upgraded.clearAllData();
    expect(
        await upgraded.customSelect('SELECT * FROM guest_notifications').get(),
        isEmpty);
  });
}
