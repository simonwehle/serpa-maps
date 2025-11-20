import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';

double adaptiveMaxZoom({required WidgetRef ref}) {
  final activeLayer = ref.watch(activeLayerProvider);
  switch (activeLayer) {
    case MapLayer.vector:
      return 18;
    case MapLayer.osm:
      return 20;
    case MapLayer.satellite:
      return 20;
  }
}
