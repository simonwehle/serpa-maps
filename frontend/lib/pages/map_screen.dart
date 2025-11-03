import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/providers/location_permission_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:serpa_maps/services/marker_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  List<Marker> markerList = [];
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    getPlaceMarkers();
  }

  Future<void> getPlaceMarkers() async {
    final markers = await createPlaceMarkers(ref);
    setState(() {
      markerList = markers;
    });
  }

  void openAddPlaceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      //barrierColor: Colors.transparent,
      builder: (_) => AddPlaceBottomSheet(),
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
          // Orientation Lock
          // interactionOptions: const InteractionOptions(
          //   flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          // ),
          cameraConstraint: const CameraConstraint.containLatitude(),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.serpamaps.app',
          ),
          const MapCompass.cupertino(
            hideIfRotatedNorth: true,
            padding: EdgeInsets.fromLTRB(0, 50, 10, 0),
          ),
          MarkerLayer(markers: markerList),
          if (ref.watch(locationPermissionProvider)) CurrentLocationLayer(),
          RichAttributionWidget(
            alignment: AttributionAlignment.bottomLeft,
            showFlutterMapAttribution: false,
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
              TextSourceAttribution(
                "Made with 'flutter_map'",
                prependCopyright: false,
                textStyle: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
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
