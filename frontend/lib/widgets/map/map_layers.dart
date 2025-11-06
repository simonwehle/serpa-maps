import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

List<Widget> buildMapBaseLayers(
  Style? style,
  String activeLayer, {
  required String apiKey,
}) {
  final List<Widget> layers = [];

  // OSM raster
  if (activeLayer == 'OSM') {
    layers.add(
      TileLayer(
        urlTemplate: 'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.serpamaps.app',
      ),
    );
  }

  // Pure vector
  if (activeLayer == 'Vector' && style != null) {
    layers.add(
      VectorTileLayer(
        tileProviders: style.providers,
        theme: style.theme,
        tileOffset: TileOffset.DEFAULT,
      ),
    );
  }

  // Satellite raster (MapTiler) + optional vector overlay (hybrid)
  if (activeLayer == 'Satellite') {
    layers.add(
      TileLayer(
        urlTemplate:
            'https://api.maptiler.com/tiles/satellite/{z}/{x}/{y}.jpg?key=$apiKey',
        userAgentPackageName: 'com.serpamaps.app',
      ),
    );
  }

  return layers;
}
