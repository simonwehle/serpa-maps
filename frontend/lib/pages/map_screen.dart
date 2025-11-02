import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:serpa_maps/services/marker_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  List<Marker> markerList = [];

  @override
  void initState() {
    super.initState();
    getPlaceMarkers();
  }

  Future getPlaceMarkers() async {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openAddPlaceBottomSheet();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
