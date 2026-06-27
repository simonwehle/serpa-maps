import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/providers/preferences/overlay_url_provider.dart';

final Dio _dio = Dio();

const String _rasterSourceId = 'overlay-raster-source';
const String _rasterLayerId = 'overlay-raster-layer';
const String _vectorSourceId = 'overlay-geojson-source';

List<String> _vectorLayerIds = [];

Future<void> addOverlay({
  required MapLibreMapController mapController,
  required WidgetRef ref,
}) async {
  final overlayUrl = ref.read(overlayUrlProvider);
  if (overlayUrl == "") return;

  if (overlayUrl.contains('{z}/{x}/{y}')) {
    try {
      await mapController.addSource(
        _rasterSourceId,
        RasterSourceProperties(tiles: [overlayUrl], tileSize: 256),
      );
      await mapController.addRasterLayer(
        _rasterSourceId,
        _rasterLayerId,
        RasterLayerProperties(rasterOpacity: 1.0),
        belowLayerId: 'places-clusters',
      );
    } catch (_) {}
    return;
  }

  try {
    final response = await _dio.get(overlayUrl);
    final Map<String, dynamic> body = response.data is String
        ? jsonDecode(response.data)
        : Map<String, dynamic>.from(response.data);

    final Map<String, dynamic> geojson = Map<String, dynamic>.from(
      body['source'],
    );
    final List layers = (body['layers'] as List?) ?? [];

    await mapController.addGeoJsonSource(_vectorSourceId, geojson);

    final addedIds = <String>[];
    for (final layer in layers) {
      final String layerId = layer['id'];
      final Map<String, dynamic>? paint = layer['paint'] != null
          ? Map<String, dynamic>.from(layer['paint'])
          : null;

      if (layer['type'] != 'line') continue;

      await mapController.addLineLayer(
        _vectorSourceId,
        layerId,
        LineLayerProperties(
          lineColor: paint?['line-color'],
          lineWidth: paint?['line-width'],
          lineOpacity: paint?['line-opacity'],
          lineBlur: paint?['line-blur'],
        ),
        belowLayerId: 'places-clusters',
      );
      addedIds.add(layerId);
    }
    _vectorLayerIds = addedIds;
  } catch (_) {}
}

Future<void> removeOverlay({
  required MapLibreMapController mapController,
}) async {
  try {
    await mapController.removeLayer(_rasterLayerId);
    await mapController.removeSource(_rasterSourceId);
  } catch (_) {}

  try {
    for (final layerId in _vectorLayerIds) {
      await mapController.removeLayer(layerId);
    }
    _vectorLayerIds = [];
    await mapController.removeSource(_vectorSourceId);
  } catch (_) {}
}
