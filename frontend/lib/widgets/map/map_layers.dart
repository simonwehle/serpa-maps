import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart';

Widget mapBaseLayer({
  required String activeLayer,
  required VectorTileProvider protoMapsProvider,
}) {
  return switch (activeLayer) {
    'Vector' => VectorTileLayer(
      key: ValueKey('vector'),
      tileProviders: TileProviders({'protomaps': protoMapsProvider}),
      theme: ProtomapsThemes.lightV3(),
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
