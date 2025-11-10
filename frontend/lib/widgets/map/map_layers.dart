import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

Widget mapBaseLayer({required Style? style, required String activeLayer}) {
  return switch (activeLayer) {
    'Vector' when style != null => VectorTileLayer(
      tileProviders: style.providers,
      theme: style.theme,
      tileOffset: TileOffset.DEFAULT,
    ),
    'OSM' => TileLayer(
      urlTemplate: 'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png',
      userAgentPackageName: 'org.serpamaps',
    ),
    'Satellite' => TileLayer(
      urlTemplate:
          'https://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      userAgentPackageName: 'org.serpamaps',
    ),
    _ => const SizedBox.shrink(),
  };
}
