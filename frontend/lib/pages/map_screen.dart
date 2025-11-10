import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import 'package:serpa_maps/providers/location_permission_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/widgets/map/attribution_widget.dart';
import 'package:serpa_maps/widgets/map/map_layers.dart';
import 'package:serpa_maps/widgets/map/place_markers_layer.dart';
import 'package:serpa_maps/widgets/map/pmtiles_layer.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/layer_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  Style? style;
  String activeLayer = 'Vector';

  @override
  void initState() {
    super.initState();

    StyleReader(
      uri: 'https://tiles.openfreemap.org/styles/liberty',
      //logger: const Logger.console(),
    ).read().then((style) {
      this.style = style;

      setState(() {});
    });
  }

  void openAddPlaceBottomSheet({double? latitude, double? longitude}) {
    showSerpaBottomSheet(
      context: context,
      child: AddPlaceBottomSheet(latitude: latitude, longitude: longitude),
    );
  }

  void openLayerBottomSheet() {
    showSerpaBottomSheet(
      context: context,
      child: LayerBottomSheet(
        activeLayer: activeLayer,
        onLayerSelected: (layer) {
          setState(() {
            activeLayer = layer;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 2,
          minZoom: 1,
          maxZoom: 20,
          onMapReady: () async {
            await ref
                .read(locationPermissionProvider.notifier)
                .checkPermissionOrZoomMap(_mapController);
          },
          interactionOptions: const InteractionOptions(
            // reduce rotation on pinch zoom
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
          mapBaseLayer(style: style, activeLayer: activeLayer),
          PmtilesLayer(),
          if (ref.watch(markersVisibleProvider)) PlaceMarkersLayer(),
          if (ref.watch(locationPermissionProvider)) CurrentLocationLayer(),
          const MapCompass.cupertino(
            hideIfRotatedNorth: true,
            padding: EdgeInsets.fromLTRB(0, 50, 10, 0),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 10, 0),
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: openLayerBottomSheet,
                shape: CircleBorder(),
                child: const Icon(Icons.layers),
              ),
            ),
          ),
          AttributionWidget(activeLayer: activeLayer),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: () async {
              await ref
                  .read(locationPermissionProvider.notifier)
                  .requestLocationOrZoomMap(_mapController);
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () {
              openAddPlaceBottomSheet();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
