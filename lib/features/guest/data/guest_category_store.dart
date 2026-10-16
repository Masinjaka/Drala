import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/guest/data/guest_database.dart';
import 'package:budgets/features/guest/data/guest_sync_journal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class GuestCategoryStore {
  const GuestCategoryStore(this.database, this.userId);

  final GuestDatabase database;
  final String userId;

  Future<List<Category>> categories() async {
    final rows = await database.customSelect(
      '''SELECT id,name,emoji,color,transaction_type FROM guest_categories
         WHERE user_id = ? ORDER BY name''',
      variables: [Variable.withString(userId)],
    ).get();
    return rows
        .map((row) => Category.fromMap(row.data))
        .toList(growable: false);
  }

  Future<String> add(Category category) async {
    final id = const Uuid().v4();
    final now = DateTime.now().toUtc().toIso8601String();
    await database.transaction(() async {
      await database.customInsert(
        '''INSERT INTO guest_categories
           (id,user_id,name,transaction_type,emoji,color,icon_key,created_at,updated_at)
           VALUES(?,?,?,?,?,?,'other',?,?)''',
        variables: [
          Variable.withString(id),
          Variable.withString(userId),
          Variable.withString(category.name ?? ''),
          Variable.withString(category.transactionType?.value ?? 'expense'),
          Variable.withString(category.emoji ?? '🧾'),
          Variable<String>(category.color),
          Variable.withString(now),
          Variable.withString(now),
        ],
      );
      await GuestSyncJournal(database).record('categories', id, 'upsert', {
        'id': id,
        'name': category.name,
        'transaction_type': category.transactionType?.value ?? 'expense',
        'emoji': category.emoji,
        'color': category.color,
        'icon_key': 'other',
      });
    });
    return id;
  }

  Future<String> update(Category category) async {
    final id = category.id;
    if (id == null) throw ArgumentError('Category ID is required.');
    await database.transaction(() async {
      final changed = await database.customUpdate(
        '''UPDATE guest_categories SET name=?,emoji=?,color=?,updated_at=?
           WHERE id=? AND user_id=?''',
        variables: [
          Variable.withString(category.name ?? ''),
          Variable.withString(category.emoji ?? '🧾'),
          Variable<String>(category.color),
          Variable.withString(DateTime.now().toUtc().toIso8601String()),
          Variable.withString(id),
          Variable.withString(userId),
        ],
      );
      if (changed == 0) throw StateError('Category not found.');
      await GuestSyncJournal(database).record('categories', id, 'upsert', {
        'id': id,
        'name': category.name,
        'emoji': category.emoji,
        'color': category.color,
      });
    });
    return id;
  }

  Future<String> delete(Category category) async {
    final id = category.id;
    if (id == null) throw ArgumentError('Category ID is required.');
    await database.transaction(() async {
      final used = await database.customSelect(
        '''SELECT 1 FROM guest_transactions WHERE category_id = ?
           UNION SELECT 1 FROM guest_envelopes WHERE category_id = ? LIMIT 1''',
        variables: [Variable.withString(id), Variable.withString(id)],
      ).get();
      if (used.isNotEmpty) throw StateError('Category is in use.');
      final changed = await database.customUpdate(
        'DELETE FROM guest_categories WHERE id=? AND user_id=?',
        variables: [Variable.withString(id), Variable.withString(userId)],
      );
      if (changed == 0) throw StateError('Category not found.');
      await GuestSyncJournal(database).record('categories', id, 'delete', {});
    });
    return id;
  }
}
