import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

// maybe change type to PermissionStatus

final locationPermissionProvider =
    NotifierProvider<LocationPermissionNotifier, bool>(
      LocationPermissionNotifier.new,
    );

class LocationPermissionNotifier extends Notifier<bool> {
  @override
  bool build() {
    // call checkLocationServiceStatus here
    return false;
  }

  Future<bool> checkLocationServiceStatus() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = false;
      return false;
    }
    state = true;
    return true;
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      state = false;
      return false;
    }
    state = true;
    return true;
  }
}
