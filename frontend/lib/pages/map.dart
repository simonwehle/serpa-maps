import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _controllerCompleter = Completer<MapLibreMapController>();
  bool _styleLoaded = false;

  static const _initial = CameraPosition(target: LatLng(0, 0), zoom: 2);

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['API_KEY'];
    return Scaffold(
      floatingActionButton: _styleLoaded
          ? FloatingActionButton.small(
              onPressed: _addSymbol,
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

  Future<void> _addSymbol() async {
    print('Button Pressed');
    final c = await _controllerCompleter.future;
    await c.addSymbol(
      SymbolOptions(
        geometry: LatLng(37.7749, -122.4194),
        iconImage: 'assets/marker.png',
        iconSize: 1.2,
      ),
    );
  }
}
