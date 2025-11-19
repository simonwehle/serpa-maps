import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

class MapBaseLayer extends ConsumerWidget {
  final Style style;
  const MapBaseLayer({super.key, required this.style});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLayer = ref.watch(activeLayerProvider);
    return switch (activeLayer) {
      MapLayer.vector => VectorTileLayer(
        tileProviders: style.providers,
        theme: style.theme,
        tileOffset: TileOffset.DEFAULT,
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
