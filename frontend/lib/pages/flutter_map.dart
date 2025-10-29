import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:serpa_maps/widgets/markers/place_marker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FlutterMapScreen extends StatefulWidget {
  const FlutterMapScreen({super.key});
  @override
  State<FlutterMapScreen> createState() => _FlutterMapScreenState();
}

class _FlutterMapScreenState extends State<FlutterMapScreen> {
  Style? style;

  @override
  void initState() {
    super.initState();

    StyleReader(
      uri: 'https://api.maptiler.com/maps/streets/style.json?key={key}',
      // ignore: undefined_identifier
      apiKey: dotenv.env['API_KEY'],
      //logger: const Logger.console(),
    ).read().then((style) {
      this.style = style;
      setState(() {});
    });
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
        // TileLayer(
        //   // Bring your own tiles
        //   urlTemplate:
        //       'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png', // For demonstration only
        //   userAgentPackageName: 'com.serpamaps.app', // Add your app identifier
        //   // And many more recommended properties!
        // ),
        VectorTileLayer(
          tileProviders: style!.providers,
          theme: style!.theme,
          tileOffset: TileOffset.DEFAULT,
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(51.509364, -0.128928),
              width: 25,
              height: 25,
              child: PlaceMarker(icon: Icons.camera_alt, color: Colors.purple),
            ),
          ],
        ),
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
