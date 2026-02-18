import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/providers/overlay_url_provider.dart';

Future<void> addOverlay({
  required MapLibreMapController mapController,
  required WidgetRef ref,
}) async {
  final overlayUrl = ref.read(overlayUrlProvider);
  if (overlayUrl == "") return;

  try {
    await mapController.addSource(
      'overlay-source',
      RasterSourceProperties(tiles: [overlayUrl], tileSize: 256),
    );
    await mapController.addRasterLayer(
      'overlay-source',
      'overlay-layer',
      RasterLayerProperties(rasterOpacity: 1.0),
      belowLayerId: 'places-clusters',
    );
  } catch (_) {}
}

Future<void> removeOverlay({
  required MapLibreMapController mapController,
}) async {
  try {
    await mapController.removeLayer('overlay-layer');
    await mapController.removeSource('overlay-source');
  } catch (_) {}
}
