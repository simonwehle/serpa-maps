import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionWidget extends StatelessWidget {
  final String activeLayer;

  const AttributionWidget({super.key, required this.activeLayer});

  @override
  Widget build(BuildContext context) {
    return RichAttributionWidget(
      alignment: AttributionAlignment.bottomLeft,
      showFlutterMapAttribution: false,
      attributions:
          {
            'Vector': [
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
            'OSM': [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () =>
                    launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
            'Satellite': [
              TextSourceAttribution(
                'Powered by Esri',
                prependCopyright: false,
                onTap: () => launchUrl(Uri.parse('https://www.esri.com')),
              ),
              TextSourceAttribution('Sources: Esri,', prependCopyright: false),
              TextSourceAttribution('Maxar,', prependCopyright: false),
              TextSourceAttribution(
                'Earthstar Geographics',
                prependCopyright: false,
              ),
              TextSourceAttribution(
                'and the GIS User Community',
                prependCopyright: false,
              ),
            ],
          }[activeLayer] ??
          [],
    );
  }
}
