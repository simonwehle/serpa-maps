import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/providers/data/place_provider.dart';
import 'package:serpa_maps/providers/data/category_provider.dart';

final placeByIdProvider = Provider.family<Place?, String>((ref, placeId) {
  final placesAsync = ref.watch(placeProvider);
  return placesAsync.maybeWhen(
    data: (places) => places.firstWhereOrNull((p) => p.id == placeId),
    orElse: () => null,
  );
});

final categoryByIdProvider = Provider.family<Category?, String>((
  ref,
  categoryId,
) {
  final categoryAsync = ref.watch(categoryProvider);
  return categoryAsync.maybeWhen(
    data: (categories) =>
        categories.firstWhereOrNull((c) => c.id == categoryId),
    orElse: () => null,
  );
});
