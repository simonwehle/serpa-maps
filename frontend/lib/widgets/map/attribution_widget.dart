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

    // Fix: Prepare the attributions list before passing to the widget
    List<SourceAttribution> attributions = [];

    if (activeLayer == MapLayer.vector) {
      attributions = [
        TextSourceAttribution(
          'OpenMapTiles',
          onTap: () => launchUrl(Uri.parse('https://openmaptiles.org/')),
        ),
        TextSourceAttribution(
          'OpenStreetMap contributors',
          onTap: () =>
              launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
        ),
      ];
    } else if (activeLayer == MapLayer.osm) {
      attributions = [
        TextSourceAttribution(
          'OpenStreetMap contributors',
          onTap: () =>
              launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
        ),
      ];
    } else if (activeLayer == MapLayer.satellite) {
      attributions = [
        TextSourceAttribution(
          'Powered by Esri',
          prependCopyright: false,
          onTap: () => launchUrl(Uri.parse('https://www.esri.com')),
        ),
        TextSourceAttribution('Sources: Esri,', prependCopyright: false),
        TextSourceAttribution('Maxar,', prependCopyright: false),
        TextSourceAttribution('Earthstar Geographics', prependCopyright: false),
        TextSourceAttribution(
          'and the GIS User Community',
          prependCopyright: false,
        ),
      ];
    }

    return RichAttributionWidget(
      alignment: AttributionAlignment.bottomLeft,
      showFlutterMapAttribution: false,
      attributions: attributions,
    );
  }
}
