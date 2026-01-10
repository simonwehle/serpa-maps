import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/style_dark_provider.dart';
import 'package:serpa_maps/providers/style_provider.dart';

enum MapLayer { vector, osm, satellite }

String getMapLayerStyleUrl(
  MapLayer layer,
  Brightness brightness,
  WidgetRef ref,
) {
  switch (layer) {
    case MapLayer.vector:
      if (brightness == Brightness.dark) {
        return ref.watch(styleDarkUrlProvider);
      }
      return ref.watch(styleUrlProvider);
    case MapLayer.osm:
      return 'assets/styles/osm.json';
    case MapLayer.satellite:
      return 'assets/styles/arcgis.json';
  }
}

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
