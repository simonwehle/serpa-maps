import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_settings/app_settings.dart';

import 'package:serpa_maps/services/location_permission.dart';
import 'package:serpa_maps/services/marker_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  bool _permissionGranted = false;
  List<Marker> markerList = [];
  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    checkPermission();
    getPlaceMarkers();
  }

  void checkPermission() async {
    bool granted = await requestPermission();
    setState(() {
      _permissionGranted = granted;
    });
  }

  Future getPlaceMarkers() async {
    final markers = await createPlaceMarkers(ref);
    setState(() {
      markerList = markers;
    });
  }

  Future zoomToLocationMarker() async {
    final Position location = await Geolocator.getCurrentPosition();
    final latlng = LatLng(location.latitude, location.longitude);
    double zoom = 13.0;
    _mapController.move(latlng, zoom);
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
          if (_permissionGranted) CurrentLocationLayer(),
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
            onPressed: () {
              if (!_permissionGranted) {
                AppSettings.openAppSettings(type: AppSettingsType.location);
              } else {
                zoomToLocationMarker();
              }
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () => print("Add button pressed"),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
