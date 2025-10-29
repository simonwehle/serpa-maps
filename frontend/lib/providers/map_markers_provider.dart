import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/map_controller_provider.dart';
import 'package:serpa_maps/providers/tapped_place_provider.dart';
import 'package:serpa_maps/services/place_service.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';

final mapMarkersProvider =
    NotifierProvider<MapMarkersNotifier, Map<int, Symbol>>(
      MapMarkersNotifier.new,
    );

class MapMarkersNotifier extends Notifier<Map<int, Symbol>> {
  MapLibreMapController? mapController;

  @override
  Map<int, Symbol> build() {
    mapController = ref.watch(mapControllerProvider);
    return {};
  }

  Future<void> addAllPlaceMarkers(
    List<Place> places,
    List<Category> categories,
  ) async {
    if (mapController == null) return;
    final controller = mapController!;

    await controller.clearSymbols();

    final Map<int, Symbol> newSymbols = {};

    for (final place in places) {
      final category = categories.firstWhereOrNull(
        (c) => c.id == place.categoryId,
      );
      if (category == null) {
        throw Exception('Category not found for place ${place.id}');
      }
      final symbol = await addPlaceMarkerInternal(place, category, controller);
      newSymbols[place.id] = symbol;
    }

    state = newSymbols;

    _setupSymbolTapListener(controller);
  }

  Future<Symbol> addPlaceMarker(Place place, Category category) async {
    if (mapController == null) {
      throw Exception('Map controller not initialized');
    }
    final controller = mapController!;

    final symbol = await addPlaceMarkerInternal(place, category, controller);
    final newState = {...state};
    newState[place.id] = symbol;
    state = newState;

    _setupSymbolTapListener(controller);

    return symbol;
  }

  Future<void> updateAllMarkers(
    List<Place> places,
    List<Category> categories,
  ) async {
    if (mapController == null) return;
    final controller = mapController!;

    for (final symbol in state.values) {
      await controller.removeSymbol(symbol);
    }

    final Map<int, Symbol> newSymbols = {};

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

      newSymbols[place.id] = symbol;
    }

    state = newSymbols;

    _setupSymbolTapListener(controller);
  }

  Future<void> deletePlaceMarker(int placeId) async {
    if (mapController == null) {
      throw Exception('Map controller not initialized');
    }
    final controller = mapController!;

    final existingSymbol = state[placeId];
    if (existingSymbol != null) {
      await controller.removeSymbol(existingSymbol);
      final newState = {...state};
      newState.remove(placeId);
      state = newState;
    }
  }

  Future<Symbol> addPlaceMarkerInternal(
    Place place,
    Category category,
    MapLibreMapController controller,
  ) async {
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

    return symbol;
  }

  void _setupSymbolTapListener(MapLibreMapController controller) {
    controller.onSymbolTapped.clear();
    controller.onSymbolTapped.add((symbol) {
      final tappedEntry = state.entries.firstWhereOrNull(
        (e) => e.value.id == symbol.id,
      );
      if (tappedEntry != null) {
        ref.read(tappedPlaceIdProvider.notifier).setPlaceId(tappedEntry.key);
      }
    });
  }
}
