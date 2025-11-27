import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/providers/location_permission_provider.dart';

class SerpaFab extends ConsumerWidget {
  final MapLibreMapController mapController;
  final VoidCallback openAddPlaceBottomSheet;
  const SerpaFab({
    super.key,
    required this.mapController,
    required this.openAddPlaceBottomSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const CircleBorder(),
            onPressed: () async {
              await ref
                  .read(locationPermissionProvider.notifier)
                  .requestLocationOrZoomMap(mapController);
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: openAddPlaceBottomSheet,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
