import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rotation_sensor/flutter_rotation_sensor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:serpa_maps/services/marker_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  List<Marker> markerList = [];
  late final Stream<LocationMarkerPosition?> _positionStream;
  late final Stream<LocationMarkerHeading?> _headingStream;
  late final Stream<Position?> _geolocatorStream;
  late final Stream<OrientationEvent> _rotationSensorStream;

  @override
  void initState() {
    super.initState();
    const factory = LocationMarkerDataStreamFactory();
    // _positionStream = factory
    //     .fromGeolocatorPositionStream()
    //     .asBroadcastStream();
    // _headingStream = factory
    //     .fromRotationSensorHeadingStream()
    //     .asBroadcastStream();
    _geolocatorStream = factory
        .defaultPositionStreamSource()
        .asBroadcastStream();
    _rotationSensorStream = factory
        .defaultHeadingStreamSource()
        .asBroadcastStream();
    _positionStream = factory.fromGeolocatorPositionStream(
      stream: _geolocatorStream,
    );
    _headingStream = factory.fromRotationSensorHeadingStream(
      stream: _rotationSensorStream,
    );
    getPlaceMarkers();
  }

  Future getPlaceMarkers() async {
    final markers = await createPlaceMarkers(ref);
    setState(() {
      markerList = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(0, 0),
          initialZoom: 2,
          minZoom: 0,
          maxZoom: 19,
          // Orientation Lock
          // interactionOptions: const InteractionOptions(
          //   flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          // ),
        ),
        children: [
          TileLayer(
            // Bring your own tiles
            urlTemplate:
                'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png', // For demonstration only
            userAgentPackageName:
                'com.serpamaps.app', // Add your app identifier
            // And many more recommended properties!
          ),
          CurrentLocationLayer(
            positionStream: _positionStream,
            headingStream: _headingStream,
          ),
          const MapCompass.cupertino(
            hideIfRotatedNorth: true,
            padding: EdgeInsets.fromLTRB(0, 40, 10, 0),
          ),
          MarkerLayer(markers: markerList),
          RichAttributionWidget(
            // Include a stylish prebuilt attribution widget that meets all requirments
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(
                  Uri.parse('https://openstreetmap.org/copyright'),
                ), // (external)
              ),
              // Also add images...
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("pressed"),
        child: const Icon(Icons.add),
      ),
    );
  }
}
