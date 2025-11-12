import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/location_permission_provider.dart';

class SerpaFab extends ConsumerWidget {
  final MapController mapController;
  final Function openAddPlaceBottomSheet;
  const SerpaFab({
    super.key,
    required this.mapController,
    required this.openAddPlaceBottomSheet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(0, 0, 16, 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.white,
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
              onPressed: () {
                openAddPlaceBottomSheet;
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
