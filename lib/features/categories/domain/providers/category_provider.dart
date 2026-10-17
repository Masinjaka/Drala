import 'package:budgets/features/categories/data/datasource/category_api.dart';
import 'package:budgets/features/categories/domain/models/category_model.dart';
import 'package:budgets/features/guest/data/guest_category_store.dart';
import 'package:budgets/features/guest/domain/guest_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

@Riverpod(keepAlive: true)
class Categories extends _$Categories {
  GuestCategoryStore? get _guest {
    final session = ref.read(guestSessionProvider);
    if (session?.isActive != true) {
      return null;
    }
    return GuestCategoryStore(session!.database, session.userId);
  }

  @override
  Future<List<Category>> build() {
    ref.watch(guestSessionProvider);
    return _guest?.categories() ?? getCategories();
  }

  Future<String> addSomeCategory(Category category) async {
    final previous = state.value;
    state = const AsyncValue.loading();
    try {
      final result = await (_guest?.add(category) ?? addCategory(category));
      final categories = await (_guest?.categories() ?? getCategories());
      state = AsyncValue.data(categories);
      return result;
    } catch (e, s) {
      state =
          previous == null ? AsyncValue.error(e, s) : AsyncValue.data(previous);
      rethrow;
    }
  }

  Future<String> editSomeCategory(Category category) async {
    final previous = state.value;
    // state = const AsyncValue.loading();
    try {
      final result = await (_guest?.update(category) ?? editCategory(category));
      final categories = await (_guest?.categories() ?? getCategories());
      state = AsyncValue.data(categories);
      return result;
    } catch (e, s) {
      state =
          previous == null ? AsyncValue.error(e, s) : AsyncValue.data(previous);
      rethrow;
    }
  }

  Future<String> deleteSomeCategory(Category category) async {
    final previous = state.value;
    state = const AsyncValue.loading();
    try {
      final result =
          await (_guest?.delete(category) ?? deleteCategory(category));
      final categories = await (_guest?.categories() ?? getCategories());
      state = AsyncValue.data(categories);
      return result;
    } catch (e, s) {
      state =
          previous == null ? AsyncValue.error(e, s) : AsyncValue.data(previous);
      rethrow;
    }
  }
}
