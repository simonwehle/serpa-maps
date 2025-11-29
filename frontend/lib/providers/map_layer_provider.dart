import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MapLayer { vector, osm, satellite }

extension MapLayerExtension on MapLayer {
  String get styleUrl {
    switch (this) {
      case MapLayer.vector:
        return dotenv.env['STYLE_URL'] ??
            'http://localhost:3465/styles/liberty.json';
      case MapLayer.osm:
        return 'assets/styles/osm.json';
      case MapLayer.satellite:
        return 'assets/styles/arcgis.json';
    }
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
