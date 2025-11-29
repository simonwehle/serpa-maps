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
    final bytes = await createMarkerImage(
      iconFromString(category.icon),
      colorFromHex(category.color),
    );
    await mapController.addImage(category.id.toString(), bytes);
  }

  final defaultBytes = await createMarkerImage(Icons.location_pin, Colors.red);
  await mapController.addImage("default-marker", defaultBytes);
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

  await mapController.addSymbolLayer(
    "places", // source id
    "places-layer", // layer id
    SymbolLayerProperties(iconImage: matchExpression, iconSize: 0.5),
    enableInteraction: true,
  );
}

Future<void> updatePlacesSource({
  required MapLibreMapController mapController,
  required List<Place>? places,
  required bool markersVisible,
  required bool sourceAdded,
}) async {
  final placesGeoJson = {
    "type": "FeatureCollection",
    "features": markersVisible
        ? places?.map((place) {
                return {
                  "type": "Feature",
                  "id": place.id,
                  "properties": {"categoryId": place.categoryId},
                  "geometry": {
                    "type": "Point",
                    "coordinates": [place.longitude, place.latitude],
                  },
                };
              }).toList() ??
              []
        : [],
  };

  if (!sourceAdded) {
    await mapController.addSource(
      "places",
      GeojsonSourceProperties(data: placesGeoJson),
    );
  } else {
    await mapController.setGeoJsonSource("places", placesGeoJson);
  }
}
