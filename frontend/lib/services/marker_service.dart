import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';
import 'package:serpa_maps/widgets/markers/clickable_marker.dart';

List<Marker> createPlaceMarkersSync({
  required List<Place> places,
  required List<Category> categories,
  required void Function(int) onTap,
}) {
  final List<Marker> markerList = [];

  for (final place in places) {
    final category = categories.firstWhereOrNull(
      (c) => c.id == place.categoryId,
    );
    if (category == null) continue;

    IconData icon = iconFromString(category.icon);
    Color color = colorFromHex(category.color);

    markerList.add(
      Marker(
        key: Key(place.id.toString()),
        point: LatLng(place.latitude, place.longitude),
        child: ClickableMarker(
          icon: icon,
          color: color,
          placeId: place.id,
          onTap: onTap,
        ),
      ),
    );
  }

  return markerList;
}
