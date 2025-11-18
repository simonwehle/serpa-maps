import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:serpa_maps/utils/adaptive_max_zoom.dart';
import 'package:serpa_maps/widgets/map/layer_button.dart';
import 'package:serpa_maps/widgets/map/serpa_fab.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import 'package:serpa_maps/providers/location_permission_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/widgets/map/attribution_widget.dart';
import 'package:serpa_maps/widgets/map/map_layers.dart';
import 'package:serpa_maps/widgets/map/place_markers_layer.dart';
import 'package:serpa_maps/widgets/map/overlay_layer.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/layer_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  //final _mapController = MapController();
  late Future<Style> styleFuture;

  // camera state
  LatLng? lastCenter;
  double? lastZoom;
  double? lastRotation;

  // style futures
  late Future<Style> lightStyleFuture;
  late Future<Style> darkStyleFuture;

  // map controllers
  late MapController lightController;
  late MapController darkController;

  // map builder
  Widget _buildMap({
    required Key key,
    required MapController controller,
    required Future<Style> styleFuture,
  }) {
    return FlutterMap(
      key: key,
      mapController: controller,
      options: MapOptions(
        initialCenter: lastCenter ?? const LatLng(0, 0),
        initialZoom: lastZoom ?? 2,
        initialRotation: lastRotation ?? 0,

        minZoom: 1,
        maxZoom: adaptiveMaxZoom(ref: ref),
        backgroundColor: Theme.of(context).colorScheme.surface,

        onMapReady: () async {
          if (lastCenter != null) {
            controller.move(lastCenter!, lastZoom ?? 2);
            controller.rotate(lastRotation ?? 0);
          }

          await ref
              .read(locationPermissionProvider.notifier)
              .checkPermissionOrZoomMap(controller);
        },

        onPositionChanged: (pos, _) {
          lastCenter = pos.center;
          lastZoom = pos.zoom;
          lastRotation = pos.rotation;
        },

        interactionOptions: const InteractionOptions(
          enableMultiFingerGestureRace: true,
        ),
        cameraConstraint: const CameraConstraint.containLatitude(),

        onLongPress: (_, point) {
          openAddPlaceBottomSheet(
            latitude: point.latitude,
            longitude: point.longitude,
          );
        },
      ),
      children: [
        FutureBuilder<Style>(
          future: styleFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return MapBaseLayer(style: snapshot.data!);
          },
        ),
        // ---- your other layers stay where they are ----
        OverlayLayer(),
        if (ref.watch(markersVisibleProvider)) PlaceMarkersLayer(),
        if (ref.watch(locationPermissionProvider)) CurrentLocationLayer(),
        const MapCompass.cupertino(
          hideIfRotatedNorth: true,
          padding: EdgeInsets.fromLTRB(0, 50, 10, 0),
        ),
        LayerButton(onPressed: openLayerBottomSheet),
        SerpaFab(
          mapController: controller,
          openAddPlaceBottomSheet: openAddPlaceBottomSheet,
        ),
        AttributionWidget(),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    lightController = MapController();
    darkController = MapController();

    lightStyleFuture = StyleReader(
      uri: 'https://tiles.openfreemap.org/styles/liberty',
    ).read();

    darkStyleFuture = StyleReader(
      uri: 'https://tiles.openfreemap.org/styles/positron',
    ).read();
  }

  void openAddPlaceBottomSheet({double? latitude, double? longitude}) {
    showSerpaBottomSheet(
      context: context,
      child: AddPlaceBottomSheet(latitude: latitude, longitude: longitude),
    );
  }

  void openLayerBottomSheet() {
    showSerpaBottomSheet(context: context, child: LayerBottomSheet());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: isDark
            ? _buildMap(
                key: const ValueKey('dark-map'),
                controller: darkController,
                styleFuture: darkStyleFuture,
              )
            : _buildMap(
                key: const ValueKey('light-map'),
                controller: lightController,
                styleFuture: lightStyleFuture,
              ),
      ),
    );
  }
}
