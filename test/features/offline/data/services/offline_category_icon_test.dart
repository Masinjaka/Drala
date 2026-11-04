import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/guest/data/guest_category_store.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/offline_fixture.dart';

void main() {
  test('offline category icon changes are uploaded with their stable key',
      () async {
    final fixture = OfflineFixture();
    addTearDown(fixture.database.close);
    await fixture.engine.sync();
    final store = GuestCategoryStore(fixture.database, fixture.id);
    final id = await store.add(Category(
        name: 'Internet',
        iconKey: 'internet',
        emoji: '',
        transactionType: TransactionType.expense));
    await fixture.engine.sync();
    final change = fixture.remote.batches.last.operations.single;
    expect(change['record_id'], id);
    expect((change['payload'] as Map)['icon_key'], 'internet');
    expect((change['payload'] as Map)['emoji'], isEmpty);
    final saved = (await store.categories()).singleWhere((c) => c.id == id);
    await store.update(saved.copyWith(iconKey: 'phone'));
    await fixture.engine.sync();
    expect(
        (fixture.remote.batches.last.operations.single['payload']
            as Map)['icon_key'],
        'phone');
  });
}
