import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import 'package:serpa_maps/services/marker_service.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  Style? style;
  List<Marker> markerList = [];

  @override
  void initState() {
    super.initState();
    StyleReader(
      uri: 'https://tiles.openfreemap.org/styles/liberty',
      // ignore: undefined_identifier
      //logger: const Logger.console(),
    ).read().then((style) {
      this.style = style;
      setState(() {});
    });
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
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(0, 0),
        initialZoom: 2,
        // Orientation Lock
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        if (style != null)
          VectorTileLayer(
            tileProviders: style!.providers,
            theme: style!.theme,
            tileOffset: TileOffset.DEFAULT,
          ),
        // TileLayer(
        //   // Bring your own tiles
        //   urlTemplate:
        //       'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png', // For demonstration only
        //   userAgentPackageName: 'com.serpamaps.app', // Add your app identifier
        //   // And many more recommended properties!
        // ),
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
