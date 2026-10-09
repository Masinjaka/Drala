import 'package:budgets/core/enums/transaction_type.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';

class TestCategories extends Categories {
  @override
  Future<List<Category>> build() async => [
        Category(
            id: 'food',
            name: 'Food',
            emoji: '🍔',
            color: 'FFFFFFFF',
            transactionType: TransactionType.expense),
        Category(
            id: 'salary',
            name: 'Salary',
            emoji: '💵',
            color: 'FFFFFFFF',
            transactionType: TransactionType.income),
      ];
}
