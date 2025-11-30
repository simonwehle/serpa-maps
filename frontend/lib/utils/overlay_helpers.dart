import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

Future<void> addOverlay({required MapLibreMapController mapController}) async {
  final overlayUrl = dotenv.env['OVERLAY_URL'];
  if (overlayUrl == null) return;

  try {
    await mapController.addSource(
      'overlay-source',
      RasterSourceProperties(tiles: [overlayUrl], tileSize: 256),
    );
    await mapController.addRasterLayer(
      'overlay-source',
      'overlay-layer',
      RasterLayerProperties(rasterOpacity: 1.0),
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
