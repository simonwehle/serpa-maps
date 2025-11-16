import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/map_layer_provider.dart';

double adaptiveMaxZoom({
  required WidgetRef ref,
  required MapController mapController,
}) {
  final activeLayer = ref.watch(activeLayerProvider);
  final zoom = mapController.camera.zoom;
  switch (activeLayer) {
    case MapLayer.vector:
      final double vectorZoom = 18;
      mapController.camera.clampZoom(max(zoom, vectorZoom));
      return vectorZoom;
    case MapLayer.osm:
      final double osmZoom = 20;
      mapController.camera.clampZoom(max(zoom, osmZoom));
      return osmZoom;
    case MapLayer.satellite:
      final double satelliteZoom = 20;
      mapController.camera.clampZoom(max(zoom, satelliteZoom));
      return satelliteZoom;
  }
}
