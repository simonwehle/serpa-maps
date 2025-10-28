import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

final locationCircleProvider =
    NotifierProvider<LocationCircleNotifier, Circle?>(
      LocationCircleNotifier.new,
    );

class LocationCircleNotifier extends Notifier<Circle?> {
  @override
  Circle? build() {
    return null;
  }

  Future<void> updateCircle(
    LatLng location,
    MapLibreMapController mapController,
  ) async {
    if (state != null) {
      await mapController.removeCircle(state!);
      state = null;
    }

    final newCircle = await mapController.addCircle(
      CircleOptions(
        geometry: location,
        circleRadius: 8,
        circleColor: "#0000FF",
        circleStrokeColor: "#FFFFFF",
        circleStrokeWidth: 4,
      ),
    );

    state = newCircle;
  }
}
