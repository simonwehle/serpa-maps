import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SimpleMapPage extends StatefulWidget {
  const SimpleMapPage({super.key});
  @override
  State<SimpleMapPage> createState() => _SimpleMapPageState();
}

class _SimpleMapPageState extends State<SimpleMapPage> {
  final _controllerCompleter = Completer<MapLibreMapController>();
  bool _styleLoaded = false;

  static const _initial = CameraPosition(target: LatLng(0, 0), zoom: 2);

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['API_KEY'];
    return Scaffold(
      floatingActionButton: _styleLoaded
          ? FloatingActionButton.small(
              onPressed: _goHome,
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
}
