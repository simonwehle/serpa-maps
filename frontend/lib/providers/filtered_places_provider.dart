import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/providers/place_search_provider.dart';

final filteredPlacesProvider = Provider<AsyncValue<List<Place>>>((ref) {
  final placesAsync = ref.watch(placeProvider);
  final query = ref.watch(placeSearchQueryProvider).toLowerCase();

  return placesAsync.whenData((places) {
    if (query.isEmpty) return places;
    return places.where((p) => p.name.toLowerCase().contains(query)).toList();
  });
});
