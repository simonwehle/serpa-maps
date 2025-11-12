import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionWidget extends ConsumerWidget {
  const AttributionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLayer = ref.watch(activeLayerProvider);
    return RichAttributionWidget(
      alignment: AttributionAlignment.bottomLeft,
      showFlutterMapAttribution: false,
      attributions: switch (activeLayer) {
        MapLayer.vector => [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
          TextSourceAttribution(
            'OpenMapTiles',
            onTap: () => launchUrl(Uri.parse('https://openmaptiles.org/')),
          ),
        ],
        MapLayer.osm => [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () =>
                launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
        MapLayer.satellite => [
          TextSourceAttribution(
            'Powered by Esri',
            prependCopyright: false,
            onTap: () => launchUrl(Uri.parse('https://www.esri.com')),
          ),
          TextSourceAttribution(
            'Sources: Esri, Maxar, Earthstar Geographics and the GIS User Community',
            prependCopyright: false,
          ),
        ],
      },
    );
  }
}
