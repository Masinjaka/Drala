import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';

class ManualEntryTestCategories extends Categories {
  @override
  Future<List<Category>> build() async => [];

  @override
  Future<String> addSomeCategory(Category category) async => 'groceries';
}
