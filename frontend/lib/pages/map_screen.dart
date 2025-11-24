import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:serpa_maps/providers/location_permission_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/utils/adaptive_max_zoom.dart';
import 'package:serpa_maps/widgets/map/layer_button.dart';
import 'package:serpa_maps/widgets/map/serpa_fab.dart';
import 'package:serpa_maps/widgets/map/attribution_widget.dart';
import 'package:serpa_maps/widgets/map/map_layers.dart';
import 'package:serpa_maps/widgets/map/place_markers_layer.dart';
import 'package:serpa_maps/widgets/map/overlay_layer.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_draggable_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/widgets/sheets/layer_bottom_sheet.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  late Future<Style> styleFuture;

  @override
  void initState() {
    super.initState();

    styleFuture = StyleReader(
      uri:
          dotenv.env['STYLE_URL'] ??
          'http://localhost:3465/styles/liberty.json',
    ).read();
  }

  void openAddPlaceBottomSheet({double? latitude, double? longitude}) {
    showSerpaDraggableSheet(
      context: context,
      child: AddPlaceBottomSheet(latitude: latitude, longitude: longitude),
    );
  }

  void openLayerBottomSheet() {
    showSerpaStaticSheet(context: context, child: LayerBottomSheet());
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
          maxZoom: adaptiveMaxZoom(ref: ref),
          backgroundColor: Theme.of(context).colorScheme.surface,
          onMapReady: () async {
            await ref
                .read(locationPermissionProvider.notifier)
                .checkPermissionOrZoomMap(_mapController);
          },
          interactionOptions: const InteractionOptions(
            /// The following option reduces rotation on pinch zoom
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                final style = snapshot.data!;
                return Stack(
                  children: [
                    MapBaseLayer(style: style),
                    OverlayLayer(),
                    if (ref.watch(markersVisibleProvider)) PlaceMarkersLayer(),
                    if (ref.watch(locationPermissionProvider))
                      CurrentLocationLayer(),
                    const MapCompass.cupertino(
                      hideIfRotatedNorth: true,
                      padding: EdgeInsets.fromLTRB(0, 50, 10, 0),
                    ),
                    LayerButton(onPressed: openLayerBottomSheet),
                    SerpaFab(
                      mapController: _mapController,
                      openAddPlaceBottomSheet: openAddPlaceBottomSheet,
                    ),
                    AttributionWidget(),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
