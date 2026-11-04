import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('category icon key survives API round trips and copyWith', () {
    final category = Category.fromMap(
        {'id': '1', 'name': 'Travel', 'emoji': '', 'icon_key': 'travel'});
    expect(category.copyWith(name: 'Trips').toMap()['icon_key'], 'travel');
    expect(Category.fromMap(category.toMap()).iconKey, 'travel');
  });
}
