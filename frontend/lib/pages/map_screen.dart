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
        children: [
          WidgetLayer(
            markers: [
              Marker(
                // must be the same dimension as the inner widget
                size: const Size.square(50),
                // the longitude / latitude position on the map
                point: Geographic(lon: -10, lat: 0),
                // child can be any flutter widget tree
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  // must be the same as Marker.size
                  size: 50,
                ),
                // the used Icon should be attached to the map at the bottom center
                alignment: Alignment.bottomCenter,
              ),
              Marker(
                // must be the same dimension as the inner widget
                size: const Size.square(50),
                // the longitude / latitude position on the map
                point: Geographic(lon: 8, lat: 49),
                // child can be any flutter widget tree
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  // must be the same as Marker.size
                  size: 50,
                ),
                // the used Icon should be attached to the map at the bottom center
                alignment: Alignment.bottomCenter,
              ),
              Marker(
                // must be the same dimension as the inner widget
                size: const Size.square(50),
                // the longitude / latitude position on the map
                point: Geographic(lon: -17, lat: 65),
                // child can be any flutter widget tree
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  // must be the same as Marker.size
                  size: 50,
                ),
                // the used Icon should be attached to the map at the bottom center
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
          const SourceAttribution(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => print("pressed"),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
