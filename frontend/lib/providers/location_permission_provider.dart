import 'package:app_settings/app_settings.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final locationPermissionProvider =
    NotifierProvider<LocationPermissionNotifier, bool>(
      LocationPermissionNotifier.new,
    );

class LocationPermissionNotifier extends Notifier<bool> {
  @override
  bool build() {
    _checkPermissionAsync();
    return false;
  }

  Future<void> _checkPermissionAsync() async {
    final isGranted = await _checkLocationServiceStatus();
    if (ref.mounted) {
      state = isGranted;
    }
  }

  Future<bool> _checkLocationServiceStatus() async {
    final permission = await Geolocator.checkPermission();
    return permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
  }

  Future<bool> _requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    final granted =
        permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;
    if (ref.mounted) {
      state = granted;
    }
    return granted;
  }

  Future<void> checkPermissionOrZoomMap(
    AnimatedMapController animatedMapController,
  ) async {
    final granted = await _checkLocationServiceStatus();
    if (granted) {
      await _zoomToLocationMarker(animatedMapController);
    }
  }

  Future<void> requestLocationOrZoomMap(
    AnimatedMapController animatedMapController,
  ) async {
    if (!state) {
      final granted = await _requestLocationPermission();
      if (!granted) {
        AppSettings.openAppSettings(type: AppSettingsType.location);
      } else {
        await _zoomToLocationMarker(animatedMapController);
      }
    } else {
      await _zoomToLocationMarker(animatedMapController);
    }
  }

  Future<void> _zoomToLocationMarker(
    AnimatedMapController animatedMapController,
  ) async {
    final position = await Geolocator.getCurrentPosition();
    final latlng = LatLng(position.latitude, position.longitude);
    animatedMapController.animateTo(dest: latlng, zoom: 14.0);
  }
}
