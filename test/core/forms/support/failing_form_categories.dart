import 'package:budgets/features/categories/domain/models/category_model.dart';
import '../../../features/categories/support/recording_categories.dart';

class FailingFormCategories extends RecordingCategories {
  @override
  Future<String> addSomeCategory(Category category) async =>
      throw StateError('Storage unavailable');
}
