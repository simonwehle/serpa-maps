import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const MyMapApp());

class MyMapApp extends StatelessWidget {
  const MyMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Maps (OSM)',
      home: Scaffold(
        appBar: AppBar(title: const Text('My Maps - OSM')),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(48.8566, 2.3522), // Paris
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.mymaps_clone',
            ),
          ],
        ),
      ),
    );
  }
}
