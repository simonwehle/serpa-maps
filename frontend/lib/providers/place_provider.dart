import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/api_provider.dart';

final placeProvider = AsyncNotifierProvider<PlaceNotifier, List<Place>>(
  PlaceNotifier.new,
);

class PlaceNotifier extends AsyncNotifier<List<Place>> {
  @override
  Future<List<Place>> build() async {
    final api = ref.read(apiServiceProvider);
    return await api.fetchPlaces();
  }

  Future<Place?> addPlace({
    required String name,
    required int categoryId,
    required double latitude,
    required double longitude,
    String? description,
  }) async {
    final api = ref.read(apiServiceProvider);
    final addedPlace = await api.addPlace(
      name: name,
      latitude: latitude,
      longitude: longitude,
      categoryId: categoryId,
    );
    state = state.whenData((places) => [...places, ?addedPlace]);
    return addedPlace;
  }

  Future<Place> updatePlace({
    required int id,
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    int? categoryId,
  }) async {
    final api = ref.read(apiServiceProvider);
    final updatedPlace = await api.updatePlace(
      id: id,
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      categoryId: categoryId,
    );
    ref.invalidateSelf();
    return updatedPlace;
  }

  Future<void> deletePlace({required int id}) async {
    final api = ref.read(apiServiceProvider);
    await api.deletePlace(id: id);
    ref.invalidateSelf();
  }
}
