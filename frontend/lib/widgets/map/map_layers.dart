import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

List<Widget> buildMapBaseLayers(
  Style? style,
  String activeLayer, {
  required String apiKey,
}) {
  final List<Widget> layers = [];

  if (activeLayer == 'Vector' && style != null) {
    layers.add(
      VectorTileLayer(
        tileProviders: style.providers,
        theme: style.theme,
        tileOffset: TileOffset.DEFAULT,
      ),
    );
  }

  if (activeLayer == 'OSM') {
    layers.add(
      TileLayer(
        urlTemplate: 'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png',
        userAgentPackageName: 'org.serpamaps',
      ),
    );
  }

  if (activeLayer == 'Satellite') {
    layers.add(
      TileLayer(
        urlTemplate:
            'https://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        userAgentPackageName: 'org.serpamaps',
      ),
    );
  }

  return layers;
}
