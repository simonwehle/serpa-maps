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

  Future<void> deletePlace({required int id}) async {
    final api = ref.read(apiServiceProvider);
    await api.deletePlace(id: id);
    ref.invalidateSelf();
  }

  Future<Place> updatePlace(
    int id, {
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    int? categoryId,
  }) async {
    final api = ref.read(apiServiceProvider);
    final updatedPlace = await api.updatePlace(
      id,
      name: name,
      description: description,
      latitude: latitude,
      longitude: longitude,
      categoryId: categoryId,
    );
    ref.invalidateSelf();
    return updatedPlace;
  }
}
