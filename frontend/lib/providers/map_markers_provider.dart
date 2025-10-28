import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/map_controller_provider.dart';
import 'package:serpa_maps/services/place_service.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';

final mapMarkersProvider =
    NotifierProvider<MapMarkersNotifier, Map<String, int>>(
      MapMarkersNotifier.new,
    );

class MapMarkersNotifier extends Notifier<Map<String, int>> {
  late final MapLibreMapController? mapController;

  @override
  Map<String, int> build() {
    mapController = ref.watch(mapControllerProvider);
    return {};
  }

  Future<void> addPlaceMarkers(
    List<Place> places,
    List<Category> categories,
  ) async {
    if (mapController == null) return;
    final controller = mapController!;

    for (final symbolId in state.keys) {
      await controller.removeSymbol(Symbol(symbolId, SymbolOptions()));
    }

    controller.onSymbolTapped.clear();

    var updatedMap = <String, int>{};

    for (final place in places) {
      final category = categories.firstWhereOrNull(
        (c) => c.id == place.categoryId,
      );
      if (category == null) continue;

      final bytes = await createMarkerImage(
        iconFromString(category.icon),
        colorFromHex(category.color),
      );

      final markerId = 'place_${place.id}';
      await controller.addImage(markerId, bytes);

      final symbol = await controller.addSymbol(
        SymbolOptions(
          geometry: LatLng(place.latitude, place.longitude),
          iconImage: markerId,
          iconSize: 0.6,
        ),
      );

      updatedMap[symbol.id] = place.id;
    }

    state = updatedMap;
  }
}
