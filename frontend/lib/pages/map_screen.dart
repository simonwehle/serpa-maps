import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/location_permission_provider.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/providers/overlay_active_prvoider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/utils/map_marker_utils.dart';
import 'package:serpa_maps/utils/overlay_helpers.dart';
import 'package:serpa_maps/widgets/map/layer_button.dart';
import 'package:serpa_maps/widgets/map/serpa_fab.dart';
import 'package:serpa_maps/widgets/map/serpa_search_bar.dart';
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
  bool _listenerAdded = false;

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
    );
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    _controller = controller;
    setState(() {
      _mapReady = true;
    });
    await ref
        .read(locationPermissionProvider.notifier)
        .checkPermissionOrZoomMap(_controller);
  }

  Future<void> _onStyleLoaded() async {
    final categories = await ref.read(categoryProvider.future);
    await addMarkerImage(categories: categories, mapController: _controller);

    final places = await ref.read(placeProvider.future);

    await updatePlacesSource(
      mapController: _controller,
      places: places,
      markersVisible: ref.read(markersVisibleProvider),
    );
    await addPlaceLayer(categories: categories, mapController: _controller);

    if (!_listenerAdded) {
      _controller.onFeatureTapped.add(onFeatureTap);
      _listenerAdded = true;
    }

    if (ref.read(overlayActiveProvider)) {
      await addOverlay(mapController: _controller);
    }
  }

  void onFeatureTap(
    Point<double> point,
    LatLng latLng,
    String id,
    String layerId,
    Annotation? annotation,
  ) {
    if (layerId == 'places-clusters' || layerId == 'places-cluster-count') {
      _controller.animateCamera(
        CameraUpdate.zoomBy(2, Offset(point.x, point.y)),
      );
    } else if (layerId == 'places-layer') {
      openPlaceBottomSheet(placeId: int.parse(id));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(placeProvider, (previous, next) {
      _updatePlaces(next.value);
    });

    ref.listen(markersVisibleProvider, (previous, next) {
      _updatePlaces(ref.read(placeProvider).value);
    });

    ref.listen(activeLayerProvider, (previous, next) async {
      if (_mapReady) {
        final brightness = MediaQuery.of(context).platformBrightness;
        await _controller.setStyle(next.getStyleUrl(brightness));
      }
    });

    ref.listen<bool>(overlayActiveProvider, (_, isActive) async {
      if (!_mapReady) return;
      if (isActive) {
        await addOverlay(mapController: _controller);
      } else {
        await removeOverlay(mapController: _controller);
      }
    });

    final activeLayer = ref.watch(activeLayerProvider);
    final brightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      body: Stack(
        children: [
          MapLibreMap(
            styleString: activeLayer.getStyleUrl(brightness),
            onMapCreated: _onMapCreated,
            myLocationEnabled: ref.watch(locationPermissionProvider),
            //trackCameraPosition: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 2,
            ),
            onStyleLoadedCallback: _onStyleLoaded,
            onMapLongClick: (point, latLng) {
              openAddPlaceBottomSheet(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              );
            },
            attributionButtonPosition: AttributionButtonPosition.bottomLeft,
          ),
          SerpaSearchBar(
            onPlaceSelected: (place) {
              // Animate map to place.latitude, place.longitude
              _controller.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(place.latitude, place.longitude),
                  14,
                ),
              );
            },
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
