import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MapLayer { vector, osm, satellite }

final activeLayerProvider = NotifierProvider<ActiveLayerNotifier, MapLayer>(
  ActiveLayerNotifier.new,
);

class ActiveLayerNotifier extends Notifier<MapLayer> {
  @override
  MapLayer build() {
    return MapLayer.vector;
  }

  void setActiveLayer(MapLayer activeLayer) {
    state = activeLayer;
  }
}
