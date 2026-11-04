import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/notifications/domain/models/finance_notification.dart';
import 'package:budgets/features/notifications/domain/repositories/finance_notification_repository.dart';
import 'package:drift/drift.dart';

class GuestNotificationRepository implements FinanceNotificationRepository {
  const GuestNotificationRepository(this.database, this.userId);
  final GuestDatabase database;
  final String userId;

  @override
  Future<List<FinanceNotification>> notifications() => _read();
  Future<List<FinanceNotification>> pending() => _read(pending: true);

  Future<List<FinanceNotification>> _read({bool pending = false}) async {
    final rows = await database.customSelect(
      '''SELECT * FROM guest_notifications WHERE user_id=?
         ${pending ? 'AND delivered=0' : ''} ORDER BY created_at DESC, id DESC''',
      variables: [Variable.withString(userId)],
    ).get();
    return rows
        .map((row) => FinanceNotification.fromJson({
              ...row.data,
              'is_read': row.read<int>('is_read') == 1,
            }))
        .toList(growable: false);
  }

  @override
  Future<void> markRead(String id) => _set(id, 'is_read');
  Future<void> markDelivered(String id) => _set(id, 'delivered');

  Future<void> _set(String id, String column) async {
    await database.transaction(() async {
      await database.customUpdate(
        'UPDATE guest_notifications SET $column=1 WHERE id=? AND user_id=?',
        variables: [Variable.withString(id), Variable.withString(userId)],
      );
      if (database.accountId != null && column == 'is_read') {
        final rows = await database.customSelect(
            'SELECT transaction_id,notification_type FROM guest_notifications WHERE id=? AND user_id=?',
            variables: [
              Variable.withString(id),
              Variable.withString(userId)
            ]).get();
        if (rows.isNotEmpty) {
          await GuestSyncJournal(database)
              .record('finance_notifications', id, 'read', rows.single.data);
        }
      }
    });
  }
}
