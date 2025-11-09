import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart';

Widget mapBaseLayer({
  required Style? style,
  required String activeLayer,
  required VectorTileProvider protoMapsProvider,
}) {
  switch (activeLayer) {
    case 'Vector':
      if (style != null) {
        return VectorTileLayer(
          key: ValueKey('vector'),
          tileProviders: style.providers,
          theme: style.theme,
          tileOffset: TileOffset.DEFAULT,
        );
      }
      return const SizedBox.shrink();
    case 'Protomaps':
      return VectorTileLayer(
        key: ValueKey('protomaps'),
        tileProviders: TileProviders({'protomaps': protoMapsProvider}),
        theme: ProtomapsThemes.lightV4(),
      );
    case 'OSM':
      return TileLayer(
        key: ValueKey('osm'),
        urlTemplate: 'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png',
        userAgentPackageName: 'org.serpamaps',
      );
    case 'Satellite':
      return TileLayer(
        key: ValueKey('satellite'),
        urlTemplate:
            'https://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        userAgentPackageName: 'org.serpamaps',
      );
    default:
      return const SizedBox.shrink();
  }
}
