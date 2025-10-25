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
}
