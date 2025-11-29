import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/utils/map_marker_utils.dart';
import 'package:serpa_maps/widgets/map/layer_button.dart';
import 'package:serpa_maps/widgets/map/serpa_fab.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_draggable_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/widgets/sheets/layer_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late MapLibreMapController _controller;
  bool _mapReady = false;
  bool _sourceAdded = false;

  void openAddPlaceBottomSheet({double? latitude, double? longitude}) {
    showSerpaDraggableSheet(
      context: context,
      child: AddPlaceBottomSheet(latitude: latitude, longitude: longitude),
    );
  }

  void openPlaceBottomSheet({required int placeId}) {
    showSerpaDraggableSheet(
      context: context,
      child: PlaceBottomSheet(placeId: placeId),
    );
  }

  void openLayerBottomSheet() {
    showSerpaStaticSheet(context: context, child: LayerBottomSheet());
  }

  Future<void> _updatePlaces(List<Place>? places) async {
    if (!_mapReady) return;

    await updatePlacesSource(
      mapController: _controller,
      places: places,
      markersVisible: ref.read(markersVisibleProvider),
      sourceAdded: _sourceAdded,
    );

    if (!_sourceAdded) {
      _sourceAdded = true;
    }
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    _controller = controller;
    setState(() {
      _mapReady = true;
    });

    final categories = await ref.read(categoryProvider.future);
    await addMarkerImage(categories: categories, mapController: _controller);

    await _updatePlaces(ref.read(placeProvider).value);

    await addPlaceLayer(categories: categories, mapController: _controller);

    controller.onFeatureTapped.add(onFeatureTap);
  }

  void onFeatureTap(
    Point<double> point,
    LatLng latLng,
    String id,
    String layerId,
    Annotation? annotation,
  ) {
    openPlaceBottomSheet(placeId: int.parse(id));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(placeProvider, (previous, next) {
      _updatePlaces(next.value);
    });

    ref.listen(markersVisibleProvider, (previous, next) {
      _updatePlaces(ref.read(placeProvider).value);
    });

    return Scaffold(
      body: Stack(
        children: [
          MapLibreMap(
            styleString: 'http://localhost:3465/styles/liberty.json',
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            //trackCameraPosition: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(43.7383, 7.4248),
              zoom: 13,
            ),
            onMapLongClick: (point, latLng) {
              openAddPlaceBottomSheet(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              );
            },
            attributionButtonPosition: AttributionButtonPosition.bottomLeft,
          ),
          LayerButton(onPressed: openLayerBottomSheet),
        ],
      ),
      floatingActionButton: !_mapReady
          ? null
          : SerpaFab(
              mapController: _controller,
              openAddPlaceBottomSheet: openAddPlaceBottomSheet,
            ),
    );
  }
}
