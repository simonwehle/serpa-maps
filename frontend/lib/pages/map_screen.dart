import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();

  late Future<Style> ofmStyle;
  late Future<Style> maptilerStyle;

  bool showOfm = true;

  final apiKey = dotenv.env['MAP_TILER'];

  @override
  void initState() {
    super.initState();

    // OpenFreeMap style
    ofmStyle = StyleReader(
      uri:
          'https://tiles.openfreemap.org/styles/liberty', // or another OFM style
    ).read();

    // MapTiler style — you need a MapTiler style JSON URL + API key
    maptilerStyle = StyleReader(
      uri: 'https://api.maptiler.com/maps/streets/style.json?key=$apiKey',
      //apiKey: 'YOUR_MAPTILER_KEY',
    ).read();
  }

  void toggleStyle() {
    setState(() {
      showOfm = !showOfm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Style>>(
        future: Future.wait([ofmStyle, maptilerStyle]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final ofm = snapshot.data![0];
          final mt = snapshot.data![1];

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(0, 0),
              initialZoom: 2,
              minZoom: 1,
              maxZoom: 18,
            ),
            children: [
              if (showOfm)
                VectorTileLayer(theme: ofm.theme, tileProviders: ofm.providers),
              if (!showOfm)
                VectorTileLayer(theme: mt.theme, tileProviders: mt.providers),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleStyle,
        child: Icon(showOfm ? Icons.map : Icons.layers),
      ),
    );
  }
}
