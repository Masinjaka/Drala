import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('guest and account files coexist without disabling duplicate warnings',
      () async {
    final messages = <String>[];
    final originalPrint = driftRuntimeOptions.debugPrint;
    driftRuntimeOptions.debugPrint = messages.add;
    addTearDown(() => driftRuntimeOptions.debugPrint = originalPrint);
    final guest = GuestDatabase(NativeDatabase.memory());
    addTearDown(guest.close);
    final account = GuestDatabase.account('user', NativeDatabase.memory());
    addTearDown(account.close);
    await guest.customStatement(
        "INSERT INTO guest_preferences (key, value, updated_at) VALUES ('test', 'guest', '2026-10-27')");
    final rows = await account
        .customSelect("SELECT value FROM guest_preferences WHERE key = 'test'")
        .get();
    expect(rows, isEmpty);
    expect(account.accountId, 'user');
    expect(messages, isEmpty);

    final duplicate = GuestDatabase.account('user', NativeDatabase.memory());
    addTearDown(duplicate.close);
    expect(messages.single, contains('WARNING (drift)'));
  });
}
