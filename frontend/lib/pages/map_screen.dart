import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/map_controller_provider.dart';
import 'package:serpa_maps/providers/map_markers_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/services/api_service.dart';
import 'package:serpa_maps/services/location_marker_service.dart';
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

      await updateLocationMarker(ref);
      await ref
          .read(mapMarkersProvider.notifier)
          .addPlaceMarkers(places, categories);
    } catch (error) {
      debugPrint('Failed to load places or categories: $error');
    }
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
      setState(() async {
        // TODO: update this function when using UUID's
        final index = places.indexWhere((p) => p.id == updatedPlace.id);
        if (index != -1) {
          places[index] = updatedPlace;
        }

        category = categories.firstWhere(
          (c) => c.id == updatedPlace.categoryId,
          orElse: () => category,
        );

        await ref
            .read(mapMarkersProvider.notifier)
            .addPlaceMarkers(places, categories);
      });
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
      setState(() async {
        final existingIndex = places.indexWhere((p) => p.id == addPlace.id);
        if (existingIndex == -1) {
          places.add(addPlace);
        } else {
          places[existingIndex] = addPlace;
        }
        await ref
            .read(mapMarkersProvider.notifier)
            .addPlaceMarkers(places, categories);
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
                onPressed: () async {
                  await updateLocationMarker(ref);
                },
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
