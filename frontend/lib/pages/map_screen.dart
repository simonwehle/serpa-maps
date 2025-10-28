import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/bottom_sheet_open_provider.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/map_controller_provider.dart';
import 'package:serpa_maps/providers/map_markers_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/providers/tapped_place_provider.dart';
import 'package:serpa_maps/services/location_marker_service.dart';
import 'package:serpa_maps/widgets/place/place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/upload_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final String baseUrl;

  bool _uploadSheetOpen = false;

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:3465";
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

  Future<void> _showBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
    required Place place,
    required Category category,
    required String baseUrl,
  }) async {
    final places = await ref.watch(placeProvider.future);
    final categories = await ref.watch(categoryProvider.future);

    final isOpen = ref.read(bottomSheetOpenProvider);
    if (isOpen) return;
    if (!isOpen) {
      ref.read(bottomSheetOpenProvider.notifier).openSheet();

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
      ref.read(bottomSheetOpenProvider.notifier).closeSheet();

      if (updatedPlace != null) {
        ref.invalidate(placeProvider);
        await ref
            .read(mapMarkersProvider.notifier)
            .addPlaceMarkers(places, categories);
      }
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
    ref.listen<int?>(tappedPlaceIdProvider, (previous, placeId) async {
      final isBottomSheetOpen = ref.watch(bottomSheetOpenProvider);
      if (placeId != null && !isBottomSheetOpen) {
        final places = await ref.watch(placeProvider.future);
        final categories = await ref.watch(categoryProvider.future);

        final place = places.firstWhereOrNull((p) => p.id == placeId);
        final category = categories.firstWhereOrNull(
          (c) => c.id == place?.categoryId,
        );

        if (place != null && category != null) {
          await _showBottomSheet(
            context: context,
            ref: ref,
            place: place,
            category: category,
            baseUrl: baseUrl,
          );
        }

        ref.read(tappedPlaceIdProvider.notifier).setPlaceId(null);
      }
    });
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
