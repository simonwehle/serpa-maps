import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:collection/collection.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/location_circle_provider.dart';
import 'package:serpa_maps/providers/map_controller_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/services/api_service.dart';
import 'package:serpa_maps/services/location_service.dart';
import 'package:serpa_maps/services/place_service.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';
import 'package:serpa_maps/widgets/place/place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/upload_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final ApiService api;
  late final String baseUrl;
  bool _bottomSheetOpen = false;
  bool _uploadSheetOpen = false;
  final Map<String, int> _symbolToPlaceId = {};

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:3465";
    api = ApiService(baseUrl, apiVersion: '/api/v1');
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    ref.read(mapControllerProvider.notifier).updateController(controller);

    try {
      final places = await ref.read(placeProvider.future);
      final categories = await ref.read(categoryProvider.future);

      await _updateLocationMarker();
      await _addPlaceMarkers(places, categories);
    } catch (error) {
      debugPrint('Failed to load places or categories: $error');
    }
  }

  Future<void> _addPlaceMarkers(
    List<Place> places,
    List<Category> categories,
  ) async {
    final mapController = ref.read(mapControllerProvider);
    if (mapController == null) return;

    for (final symbolId in _symbolToPlaceId.keys) {
      final symbol = Symbol(symbolId, SymbolOptions());
      await mapController.removeSymbol(symbol);
    }

    _symbolToPlaceId.clear();
    mapController.onSymbolTapped.clear();

    for (final place in places) {
      final category = categories.firstWhereOrNull(
        (c) => c.id == place.categoryId,
      );
      if (category == null) {
        continue;
      }

      final bytes = await createMarkerImage(
        iconFromString(category.icon),
        colorFromHex(category.color),
      );

      final markerId = 'place_${place.id}';
      await mapController.addImage(markerId, bytes);

      final symbol = await mapController.addSymbol(
        SymbolOptions(
          geometry: LatLng(place.latitude, place.longitude),
          iconImage: markerId,
          iconSize: 0.6,
        ),
      );

      _symbolToPlaceId[symbol.id] = place.id;
    }

    mapController.onSymbolTapped.add((symbol) {
      final placeId = _symbolToPlaceId[symbol.id];
      if (placeId == null) return;

      final place = places.firstWhereOrNull((p) => p.id == placeId);
      if (place == null) return;

      final category = categories.firstWhere((c) => c.id == place.categoryId);

      _showBottomSheet(place, category);
    });
  }

  Future<void> _showBottomSheet(Place place, Category category) async {
    final places = await ref.watch(placeProvider.future);
    final categories = await ref.watch(categoryProvider.future);
    if (_bottomSheetOpen) return;

    _bottomSheetOpen = true;
    final updatedPlace = await showModalBottomSheet<Place>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PlaceBottomSheet(
          place: place,
          category: category,
          categories: categories,
          baseUrl: baseUrl,
        ),
      ),
    );

    _bottomSheetOpen = false;

    if (updatedPlace != null) {
      setState(() {
        // TODO: update this function when using UUID's
        final index = places.indexWhere((p) => p.id == updatedPlace.id);
        if (index != -1) {
          places[index] = updatedPlace;
        }

        category = categories.firstWhere(
          (c) => c.id == updatedPlace.categoryId,
          orElse: () => category,
        );

        _addPlaceMarkers(places, categories);
      });
    }
  }

  Future<void> _updateLocationMarker() async {
    final mapController = ref.read(mapControllerProvider);
    if (mapController == null) return;
    try {
      final pos = await determinePosition();
      final myLocation = LatLng(pos.latitude, pos.longitude);

      await mapController.animateCamera(
        CameraUpdate.newLatLngZoom(myLocation, 13),
      );

      final locationCircle = ref.read(locationCircleProvider.notifier);
      await locationCircle.updateCircle(myLocation, mapController);
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _showUploadSheet() async {
    final places = await ref.watch(placeProvider.future);
    final categories = await ref.watch(categoryProvider.future);
    if (_uploadSheetOpen) return;

    _uploadSheetOpen = true;
    final addPlace = await showModalBottomSheet<Place>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: UploadBottomSheet(categories: categories, baseUrl: baseUrl),
      ),
    ).whenComplete(() => _uploadSheetOpen = false);

    if (addPlace != null) {
      setState(() {
        final existingIndex = places.indexWhere((p) => p.id == addPlace.id);
        if (existingIndex == -1) {
          places.add(addPlace);
        } else {
          places[existingIndex] = addPlace;
        }
        _addPlaceMarkers(places, categories);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['API_KEY'];
    return Scaffold(
      body: MapLibreMap(
        styleString:
            "https://api.maptiler.com/maps/streets/style.json?key=$apiKey",
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 2,
        ),
        onMapCreated: _onMapCreated,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 45.0, right: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white),
                onPressed: _updateLocationMarker,
              ),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'locationFab',
              onPressed: _showUploadSheet,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
