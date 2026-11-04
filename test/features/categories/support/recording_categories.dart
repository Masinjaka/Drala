import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/categories/domain/providers/category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordingCategories extends Categories {
  final saved = <Category>[];
  final edited = <Category>[];

  @override
  Future<List<Category>> build() async => [];

  @override
  Future<String> editSomeCategory(Category category) async {
    edited.add(category);
    return category.id!;
  }

  @override
  Future<String> addSomeCategory(Category category) async {
    final value = category.copyWith(id: 'internet');
    saved.add(value);
    state = AsyncData(List.of(saved));
    return value.id!;
  }
}
