import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/utils/create_marker_image.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';

Future<void> _addSingleMarkerImage({
  required Category category,
  required MapLibreMapController mapController,
}) async {
  final imageId = category.id.toString();

  try {
    final bytes = await createMarkerImage(
      iconFromString(category.icon),
      colorFromHex(category.color),
    );
    await mapController.addImage(imageId, bytes);
  } catch (_) {}
}

Future<void> addMarkerImage({
  required List<Category> categories,
  required MapLibreMapController mapController,
}) async {
  for (var category in categories) {
    await _addSingleMarkerImage(
      category: category,
      mapController: mapController,
    );
  }

  try {
    final defaultBytes = await createMarkerImage(
      Icons.location_pin,
      Colors.red,
    );
    await mapController.addImage("default-marker", defaultBytes);
  } catch (_) {}
}

Future<void> addPlaceLayer({
  required List<Category> categories,
  required MapLibreMapController mapController,
}) async {
  final matchExpression = [
    'match',
    ['get', 'categoryId'],
  ];
  for (var category in categories) {
    matchExpression.add(category.id);
    matchExpression.add(category.id.toString());
  }
  matchExpression.add('default-marker');

  try {
    await mapController.removeLayer("places-layer");
  } catch (_) {}

  try {
    await mapController.addCircleLayer(
      "places",
      "places-clusters",
      const CircleLayerProperties(
        circleColor: [
          Expressions.step,
          ['get', 'point_count'],
          '#51bbd6',
          20,
          '#FF9800',
          50,
          '#8BC34A',
        ],
        circleRadius: [
          Expressions.step,
          ['get', 'point_count'],
          15,
          20,
          17.5,
          50,
          20,
        ],
        circleStrokeWidth: 2,
        circleStrokeColor: '#ffffff',
      ),
      filter: ['has', 'point_count'],
      enableInteraction: true,
    );

    await mapController.addSymbolLayer(
      "places",
      "places-cluster-count",
      const SymbolLayerProperties(
        textField: [Expressions.get, 'point_count_abbreviated'],
        textFont: ['Noto Sans Regular'],
        textSize: 12,
        textColor: '#ffffff',
        textAllowOverlap: true,
      ),
      filter: ['has', 'point_count'],
      enableInteraction: true,
    );
  } catch (_) {}

  try {
    await mapController.addSymbolLayer(
      "places",
      "places-layer",
      SymbolLayerProperties(iconImage: matchExpression, iconSize: 0.5),
      filter: [
        '!',
        ['has', 'point_count'],
      ],
      enableInteraction: true,
    );
  } catch (_) {}
}

Future<void> updatePlacesSource({
  required MapLibreMapController mapController,
  required List<Place>? places,
  required bool markersVisible,
}) async {
  final placesGeoJson = {
    "type": "FeatureCollection",
    "features": markersVisible && places != null
        ? places.map((place) {
            return {
              "type": "Feature",
              "id": place.id,
              "properties": {"categoryId": place.categoryId},
              "geometry": {
                "type": "Point",
                "coordinates": [place.longitude, place.latitude],
              },
            };
          }).toList()
        : [],
  };

  try {
    await mapController.setGeoJsonSource("places", placesGeoJson);
  } catch (_) {
    try {
      await mapController.addSource(
        "places",
        GeojsonSourceProperties(
          data: placesGeoJson,
          cluster: true,
          clusterMaxZoom: 18,
          clusterRadius: 30,
        ),
      );
    } catch (_) {}
  }
}
