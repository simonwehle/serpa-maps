import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/utils/create_marker_image.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';

Future addMarkerImage({
  required List<Category> categories,
  required MapLibreMapController mapController,
}) async {
  for (var category in categories) {
    try {
      final bytes = await createMarkerImage(
        iconFromString(category.icon),
        colorFromHex(category.color),
      );
      await mapController.addImage(category.id.toString(), bytes);
    } catch (e) {
      // Image already exists, skip
    }
  }

  try {
    final defaultBytes = await createMarkerImage(
      Icons.location_pin,
      Colors.red,
    );
    await mapController.addImage("default-marker", defaultBytes);
  } catch (e) {
    // Image already exists, skip
  }
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
    // Circle layer for clusters only
    await mapController.addCircleLayer(
      "places",
      "places-clusters",
      const CircleLayerProperties(
        circleColor: [
          Expressions.step,
          ['get', 'point_count'],
          '#8BC34A', // Light Green for < 20 points
          20,
          '#FF9800', // Orange for >= 20 points
          50,
          '#51bbd6', // Cyan for >= 50 points
        ],
        circleRadius: [
          Expressions.step,
          ['get', 'point_count'],
          15, // Default radius for < 20 points
          20,
          17.5, // Radius for >= 20 points
          50,
          20, // Radius for >= 50 points
        ],
        circleStrokeWidth: 2,
        circleStrokeColor: '#ffffff',
      ),
      filter: ['has', 'point_count'],
      enableInteraction: true,
    );

    // Add a layer for cluster counts
    await mapController.addSymbolLayer(
      "places",
      "places-cluster-count",
      const SymbolLayerProperties(
        textField: [Expressions.get, 'point_count_abbreviated'],
        textFont: ['Noto Sans Regular'],
        textSize: 12,
        textColor: '#ffffff',
        textAllowOverlap: true, // Add this line
      ),
      filter: ['has', 'point_count'],
      enableInteraction: true,
    );

    // Symbol layer for individual markers
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
  } catch (e) {
    // Layer already exists, skip
  }
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
    await mapController.addSource(
      "places",
      GeojsonSourceProperties(
        data: placesGeoJson,
        cluster: true,
        clusterMaxZoom: 18, // Cluster at all zoom levels up to 18
        clusterRadius: 50, // Cluster points within 50px radius
      ),
    );
  } catch (e) {
    // Source already exists, ignore
  }
}
