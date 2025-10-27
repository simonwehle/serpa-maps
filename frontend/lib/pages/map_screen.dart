import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/map_controller_provider.dart';
import 'package:serpa_maps/services/api_service.dart';
import 'package:serpa_maps/services/map_service.dart';
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
  List<Place> places = [];
  List<Category> categories = [];
  late final ApiService api;
  late final String baseUrl;
  final placeService = PlaceService();
  bool _bottomSheetOpen = false;
  bool _uploadSheetOpen = false;
  Circle? _myLocationMarker;

  final Map<String, Map<String, dynamic>> _symbolData = {};

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:3465";
    api = ApiService(baseUrl, apiVersion: '/api/v1');
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      categories = await api.fetchCategories();
      places = await api.fetchPlaces();

      setState(() {});
    } catch (e) {
      throw Exception('Error while loading data: $e');
    }
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    ref.read(mapControllerProvider.notifier).updateController(controller);
    await _updateLocationMarker();
    await _addPlaceMarkers();
  }

  Future<void> _addPlaceMarkers() async {
    final mapController = ref.read(mapControllerProvider);
    if (mapController == null) return;
    for (final symbolId in _symbolData.keys) {
      final symbol = Symbol(symbolId, SymbolOptions());
      await mapController.removeSymbol(symbol);
    }

    _symbolData.clear();
    mapController.onSymbolTapped.clear();

    for (final place in places) {
      final category = categories.firstWhere(
        (c) => c.id == place.categoryId,
        orElse: () => Category(
          id: 0,
          name: "Unbekannt",
          icon: "location_on",
          color: "#999999",
        ),
      );

      final bytes = await placeService.createMarkerImage(
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

      _symbolData[symbol.id] = {'place': place, 'category': category};
    }

    mapController.onSymbolTapped.add((symbol) {
      final data = _symbolData[symbol.id];
      if (data != null) {
        _showBottomSheet(data['place'] as Place, data['category'] as Category);
      }
    });
  }

  Future<void> _showBottomSheet(Place place, Category category) async {
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
          api: api,
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

        _addPlaceMarkers();
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

      await updateMyLocationMarker(
        myLocation,
        _myLocationMarker,
        mapController,
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> _showUploadSheet() async {
    if (_uploadSheetOpen) return;

    _uploadSheetOpen = true;
    final addPlace = await showModalBottomSheet<Place>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: UploadBottomSheet(
          categories: categories,
          baseUrl: baseUrl,
          api: api,
        ),
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
        _addPlaceMarkers();
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
