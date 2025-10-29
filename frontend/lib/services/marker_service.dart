import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';
import 'package:serpa_maps/widgets/markers/place_marker.dart';

Future<List<Marker>> createPlaceMarkers(WidgetRef ref) async {
  final List<Place> places = await ref.read(placeProvider.future);
  final List<Category> categories = await ref.read(categoryProvider.future);

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
        child: PlaceMarker(icon: icon, color: color),
      ),
    );
  }

  return markerList;
}
