import 'dart:math';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';

double adaptiveMaxZoom({
  required WidgetRef ref,
  required MapController mapController,
}) {
  final activeLayer = ref.watch(activeLayerProvider);
  switch (activeLayer) {
    case MapLayer.vector:
      final double vectorZoom = 18;
      _zoomToMax(vectorZoom, mapController);
      return vectorZoom;
    case MapLayer.osm:
      final double osmZoom = 20;
      _zoomToMax(osmZoom, mapController);
      return osmZoom;
    case MapLayer.satellite:
      final double satelliteZoom = 20;
      _zoomToMax(satelliteZoom, mapController);
      return satelliteZoom;
  }
}

void _zoomToMax(double maxLayerZoom, MapController mapController) {
  try {
    final currentCenter = mapController.camera.center;
    final currentZoom = mapController.camera.zoom;
    mapController.move(currentCenter, min(maxLayerZoom, currentZoom));
  } catch (e) {
    // MapController not yet initialized, will use initial zoom
  }
}
