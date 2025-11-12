enum ActiveLayer { vector, osm, satellite }

class Layer {
  final ActiveLayer activeLayer;
  final int maxZoom;

  Layer({required this.activeLayer, required this.maxZoom});
}
