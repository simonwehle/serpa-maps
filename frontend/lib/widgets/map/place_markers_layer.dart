import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/services/marker_service.dart';
import 'package:serpa_maps/widgets/sheets/place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';

class PlaceMarkersLayer extends StatelessWidget {
  const PlaceMarkersLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final placesAsync = ref.watch(placeProvider);
        final categoriesAsync = ref.watch(categoryProvider);

        return placesAsync.when(
          data: (places) => categoriesAsync.when(
            data: (categories) {
              final markers = createPlaceMarkersSync(
                places: places,
                categories: categories,
                onTap: (placeId) => openPlaceBottomSheet(context, placeId),
              );
              return MarkerLayer(markers: markers);
            },
            loading: () => MarkerLayer(markers: []),
            error: (error, stack) => MarkerLayer(markers: []),
          ),
          loading: () => MarkerLayer(markers: []),
          error: (error, stack) => MarkerLayer(markers: []),
        );
      },
    );
  }
}

void openPlaceBottomSheet(BuildContext context, int placeId) {
  showSerpaBottomSheet(
    context: context,
    child: PlaceBottomSheet(placeId: placeId),
  );
}
