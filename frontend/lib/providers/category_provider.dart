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
}
