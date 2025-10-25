import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:serpa_maps/services/location_service.dart';
// import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _controllerCompleter = Completer<MapLibreMapController>();
  bool _styleLoaded = false;

  static const _initial = CameraPosition(target: LatLng(0, 0), zoom: 2);

  // @override
  // Future<void> initState() async {
  //   super.initState();
  //   Position position = await determinePosition();
  // }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['API_KEY'];
    return Scaffold(
      floatingActionButton: _styleLoaded
          ? FloatingActionButton.small(
              onPressed: _addMarker,
              child: const Icon(Icons.explore),
            )
          : null,
      body: MapLibreMap(
        styleString:
            "https://api.maptiler.com/maps/streets/style.json?key=$apiKey",
        initialCameraPosition: _initial,
        onMapCreated: (c) => _controllerCompleter.complete(c),
        onStyleLoadedCallback: () => setState(() => _styleLoaded = true),
      ),
    );
  }

  Future<void> _goHome() async {
    final c = await _controllerCompleter.future;
    await c.animateCamera(CameraUpdate.newCameraPosition(_initial));
  }

  Future<void> _addMarker() async {
    final controller = await _controllerCompleter.future;
    // Register an example image only once before using it in symbols
    await controller.addImage(
      'simple-marker',
      await _createMarkerImage(), // This should be a Uint8List with PNG data
    );
    await controller.addSymbol(
      SymbolOptions(
        geometry: LatLng(37.7749, -122.4194),
        iconImage: 'simple-marker',
        iconSize: 1.5,
      ),
    );
  }

  // Helper to create a simple marker image
  Future<Uint8List> _createMarkerImage() async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final size = 64.0;
    final paint = Paint()..color = Colors.red;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }
}
