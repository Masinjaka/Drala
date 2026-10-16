import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('successful sync cleanup removes all guest data', () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    final userId = guest.userId;
    const walletId = 'wallet';
    const categoryId = 'category';
    const transactionId = 'transaction';
    const now = '2026-10-14T00:00:00Z';

    await database.customInsert(
      '''INSERT INTO guest_wallets
         (id,user_id,name,balance,currency_code,created_at,updated_at)
         VALUES(?,?,?,0,'MGA',?,?)''',
      variables: [
        Variable.withString(walletId),
        Variable.withString(userId),
        Variable.withString('Cash'),
        Variable.withString(now),
        Variable.withString(now),
      ],
    );
    await database.customInsert(
      '''INSERT INTO guest_categories(id,user_id,name,transaction_type,created_at,updated_at)
         VALUES(?,?,'Food','expense',?,?)''',
      variables: [
        Variable.withString(categoryId),
        Variable.withString(userId),
        Variable.withString(now),
        Variable.withString(now),
      ],
    );
    await database.customInsert(
      '''INSERT INTO guest_transactions
         (id,user_id,title,amount,transaction_type,date,created_at,updated_at)
         VALUES(?,?,'Lunch',100,'expense',?,?,?)''',
      variables: [
        Variable.withString(transactionId),
        Variable.withString(userId),
        Variable.withString(now),
        Variable.withString(now),
        Variable.withString(now),
      ],
    );
    await database.customInsert(
      '''INSERT INTO guest_envelopes
         (id,user_id,category_id,name,amount,remaining_amount,period_month,
          funding_wallet_id,created_at,updated_at)
         VALUES('envelope',?,?,'Food',100,100,'2026-10-01',?,?,?)''',
      variables: [
        Variable.withString(userId),
        Variable.withString(categoryId),
        Variable.withString(walletId),
        Variable.withString(now),
        Variable.withString(now),
      ],
    );
    await database.customInsert(
      '''INSERT INTO guest_wallet_debits(transaction_id,wallet_id,user_id,amount)
         VALUES(?,?,?,100)''',
      variables: [
        Variable.withString(transactionId),
        Variable.withString(walletId),
        Variable.withString(userId),
      ],
    );
    await database.customInsert(
      "INSERT INTO guest_preferences(key,value,updated_at) VALUES('theme','dark',?)",
      variables: [Variable.withString(now)],
    );
    await database.customInsert(
      '''INSERT INTO guest_sync_records
         (id,table_name,record_id,operation,payload,created_at)
         VALUES('journal','wallet','wallet','insert','{}',?)''',
      variables: [Variable.withString(now)],
    );

    await guest.stopAfterSync();
    expect(guest.isActive, false);
    for (final table in const [
      'guest_profiles',
      'guest_wallets',
      'guest_categories',
      'guest_transactions',
      'guest_envelopes',
      'guest_wallet_debits',
      'guest_preferences',
      'guest_sync_records',
    ]) {
      final rows = await database.customSelect('SELECT * FROM $table').get();
      expect(rows, isEmpty, reason: table);
    }
  });

  test('failed cleanup keeps the guest active and rolls back deletions',
      () async {
    SharedPreferences.setMockInitialValues({});
    final database = GuestDatabase(NativeDatabase.memory());
    addTearDown(database.close);
    final guest = await GuestSession.load(database);
    await guest.start();
    await database.customStatement('DROP TABLE guest_sync_records');

    await expectLater(guest.stopAfterSync(), throwsA(isA<Exception>()));
    expect(guest.isActive, true);
    final rows = await database.customSelect(
      'SELECT id FROM guest_profiles WHERE id = ?',
      variables: [Variable.withString(guest.userId)],
    ).get();
    expect(rows, hasLength(1));
  });
}
