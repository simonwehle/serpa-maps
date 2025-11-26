// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:maplibre_gl/maplibre_gl.dart';

// import 'package:serpa_maps/providers/location_circle_provider.dart';
// import 'package:serpa_maps/providers/map_controller_provider.dart';
// import 'package:serpa_maps/services/location_service.dart';

// Future<void> updateLocationMarker(WidgetRef ref) async {
//   final mapController = ref.read(mapControllerProvider);
//   if (mapController == null) return;
//   try {
//     final pos = await determinePosition();
//     final myLocation = LatLng(pos.latitude, pos.longitude);

//     await mapController.animateCamera(
//       CameraUpdate.newLatLngZoom(myLocation, 13),
//     );

//     final locationCircle = ref.read(locationCircleProvider.notifier);
//     await locationCircle.updateCircle(myLocation, mapController);
//   } catch (e) {
//     debugPrint('Error getting location: $e');
//   }
// }
