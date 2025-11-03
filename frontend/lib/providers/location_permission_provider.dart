import 'package:app_settings/app_settings.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// maybe change type to PermissionStatus

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
    LocationPermission permission = await Geolocator.checkPermission();
    return !(permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever);
  }

  Future<bool> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    final granted =
        !(permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever);
    if (ref.mounted) {
      state = granted;
    }
    return granted;
  }

  Future<void> checkPermissionOrZoomMap(MapController mapController) async {
    await _checkLocationServiceStatus();
    if (state) {
      await _zoomToLocationMarker(mapController);
    }
  }

  Future<void> requestLocationOrZoomMap(MapController mapController) async {
    if (!state) {
      await _requestLocationPermission();

      if (!state) {
        AppSettings.openAppSettings(type: AppSettingsType.location);
      } else {
        await _zoomToLocationMarker(mapController);
      }
    } else {
      await _zoomToLocationMarker(mapController);
    }
  }

  Future<void> _zoomToLocationMarker(MapController mapController) async {
    final Position location = await Geolocator.getCurrentPosition();
    final latlng = LatLng(location.latitude, location.longitude);
    double zoom = 13.0;
    mapController.move(latlng, zoom);
  }
}
