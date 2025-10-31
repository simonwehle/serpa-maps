import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_compass/flutter_map_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:maplibre/maplibre.dart';

import 'package:serpa_maps/services/marker_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  List<Marker> markerList = [];
  MapController? _mapController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLibreMap(
        onMapCreated: (controller) {
          // Don't add additional annotations here,
          // wait for the onStyleLoadedCallback.
          _mapController = controller;
        },
        onStyleLoaded: (style) {
          debugPrint('Map loaded 😎');
        },
        //layers: [MarkerLayer()],
        children: [const SourceAttribution()],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => print("pressed"),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
