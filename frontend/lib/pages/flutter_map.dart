import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:serpa_maps/services/marker_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FlutterMapScreen extends ConsumerStatefulWidget {
  const FlutterMapScreen({super.key});
  @override
  ConsumerState<FlutterMapScreen> createState() => _FlutterMapScreenState();
}

class _FlutterMapScreenState extends ConsumerState<FlutterMapScreen> {
  late List<Marker> markerList;

  @override
  void initState() {
    super.initState();
    getPlaceMarkers();
  }

  Future getPlaceMarkers() async {
    markerList = await createPlaceMarkers(ref);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(51.509364, -0.128928),
        initialZoom: 9.2,
        // Orientation Lock
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        TileLayer(
          // Bring your own tiles
          urlTemplate:
              'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png', // For demonstration only
          userAgentPackageName: 'com.serpamaps.app', // Add your app identifier
          // And many more recommended properties!
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
    );
  }
}
