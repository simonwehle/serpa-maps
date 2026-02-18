import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/providers/api_provider.dart';

final categoryProvider =
    AsyncNotifierProvider<CategoryNotifier, List<Category>>(
      CategoryNotifier.new,
    );

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() async {
    final api = ref.read(apiServiceProvider);
    return await api.fetchCategories();
  }

  Future<Category?> addCategory({
    required String name,
    required String icon,
    required String color,
  }) async {
    final api = ref.read(apiServiceProvider);
    final addedCategory = await api.addCategory(
      name: name,
      icon: icon,
      color: color,
    );
    state = state.whenData(
      (categories) => [...categories, if (addedCategory != null) addedCategory],
    );
    return addedCategory;
  }

  Future<Category> updateCategory({
    required int id,
    String? name,
    String? icon,
    String? color,
  }) async {
    final api = ref.read(apiServiceProvider);
    final updatedCategory = await api.updateCategory(
      id: id,
      name: name,
      icon: icon,
      color: color,
    );
    state = state.whenData((categories) {
      final index = categories.indexWhere((c) => c.id == updatedCategory.id);
      if (index == -1) return categories;
      final updatedCategories = [...categories];
      updatedCategories[index] = updatedCategory;
      return updatedCategories;
    });
    return updatedCategory;
  }

  Future<void> deleteCategory({required int id}) async {
    final api = ref.read(apiServiceProvider);
    await api.deleteCategory(id: id);
    state = state.whenData(
      (categories) => categories.where((c) => c.id != id).toList(),
    );
  }
}
