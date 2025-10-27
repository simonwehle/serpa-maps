import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

final mapControllerProvider =
    NotifierProvider<MapControllerNotifier, MapLibreMapController?>(
      MapControllerNotifier.new,
    );

class MapControllerNotifier extends Notifier<MapLibreMapController?> {
  @override
  MapLibreMapController? build() {
    return null;
  }

  void updateController(MapLibreMapController controller) {
    state = controller;
  }
}
