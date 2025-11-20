import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_map_tiles_pmtiles/vector_map_tiles_pmtiles.dart';

class MapBaseLayer extends ConsumerWidget {
  final VectorTileProvider protoMapsProvider;
  const MapBaseLayer({super.key, required this.protoMapsProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLayer = ref.watch(activeLayerProvider);
    return switch (activeLayer) {
      MapLayer.vector => VectorTileLayer(
        key: ValueKey('vector'),
        tileProviders: TileProviders({'protomaps': protoMapsProvider}),
        theme: ProtomapsThemes.lightV3(),
      ),
      MapLayer.osm => TileLayer(
        urlTemplate: 'https://a.tile.openstreetmap.de/{z}/{x}/{y}.png',
        userAgentPackageName: 'org.serpamaps',
      ),
      MapLayer.satellite => TileLayer(
        urlTemplate:
            'https://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
      ),
    };
  }
}
