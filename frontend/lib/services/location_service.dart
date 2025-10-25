import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

Future<LatLng?> getCurrentLocation(MapLibreMapController mapController) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return null;
  }

  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  final pos = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );

  final myLocation = LatLng(pos.latitude, pos.longitude);

  await mapController?.animateCamera(
    CameraUpdate.newLatLngZoom(myLocation, 13),
  );

  return myLocation;
}
