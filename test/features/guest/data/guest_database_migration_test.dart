import 'dart:io';

import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('version 1 upgrade backfills wallet debits and adds transfers',
      () async {
    final directory = await Directory.systemTemp.createTemp('guest-migration-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}/guest.sqlite');
    final original = GuestDatabase(NativeDatabase(file));
    await original.customInsert(
      '''INSERT INTO guest_transactions
         (id,user_id,title,amount,transaction_type,date,source_wallet_id,
          envelope_amount_used,created_at,updated_at)
         VALUES('expense','guest','Lunch',8000,'expense',?,'wallet',7000,?,?)''',
      variables: [
        Variable.withString('2026-10-13T12:00:00Z'),
        Variable.withString('2026-10-13T12:00:00Z'),
        Variable.withString('2026-10-13T12:00:00Z'),
      ],
    );
    await original.customStatement('DROP TABLE guest_wallet_debits');
    await original.customStatement('DROP TABLE guest_wallet_transfers');
    await original.customStatement('PRAGMA user_version = 1');
    await original.close();

    final upgraded = GuestDatabase(NativeDatabase(file));
    addTearDown(upgraded.close);
    final debits = await upgraded.customSelect(
      'SELECT wallet_id,amount FROM guest_wallet_debits WHERE transaction_id=?',
      variables: [Variable.withString('expense')],
    ).get();
    expect(debits, hasLength(1));
    expect(debits.single.read<String>('wallet_id'), 'wallet');
    expect(debits.single.read<int>('amount'), 1000);
    final transfers = await upgraded.customSelect(
      'SELECT * FROM guest_wallet_transfers',
    ).get();
    expect(transfers, isEmpty);
  });
}
