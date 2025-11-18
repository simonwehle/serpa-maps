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
  late MapController _mapController;

  // Style futures
  late Future<Style> lightStyleFuture;
  late Future<Style> darkStyleFuture;

  // Layer visibility
  bool showLightStyle = true;

  // Camera state
  LatLng? lastCenter;
  double? lastZoom;
  double? lastRotation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    lightStyleFuture = StyleReader(
      uri: 'https://tiles.openfreemap.org/styles/liberty',
    ).read();

    darkStyleFuture = StyleReader(
      uri: 'https://tiles.openfreemap.org/styles/positron',
    ).read();
  }

  void toggleStyle() {
    setState(() {
      showLightStyle = !showLightStyle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: toggleStyle,
        child: Icon(showLightStyle ? Icons.dark_mode : Icons.light_mode),
      ),
      body: FutureBuilder<List<Style>>(
        future: Future.wait([lightStyleFuture, darkStyleFuture]),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final lightStyle = snapshot.data![0];
          final darkStyle = snapshot.data![1];

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: lastCenter ?? LatLng(0, 0),
              initialZoom: lastZoom ?? 2,
              onPositionChanged: (pos, _) {
                lastCenter = pos.center;
                lastZoom = pos.zoom;
                lastRotation = pos.rotation;
              },
              minZoom: 1,
              maxZoom: 20,
            ),
            children: [
              // Light style layer
              if (showLightStyle)
                VectorTileLayer(
                  theme: lightStyle.theme,
                  tileProviders: lightStyle.providers,
                ),

              // Dark style layer
              if (!showLightStyle)
                VectorTileLayer(
                  theme: darkStyle.theme,
                  tileProviders: darkStyle.providers,
                ),

              // Example overlay layers
              OverlayLayer(),
              if (ref.watch(markersVisibleProvider)) PlaceMarkersLayer(),
              if (ref.watch(locationPermissionProvider)) CurrentLocationLayer(),
            ],
          );
        },
      ),
    );
  }
}
