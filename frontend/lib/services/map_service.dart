import 'package:maplibre_gl/maplibre_gl.dart';

Future<void> updateMyLocationMarker(
  LatLng location,
  Circle? myLocationMarker,
  MapLibreMapController mapController,
) async {
  if (myLocationMarker != null) {
    await mapController.removeCircle(myLocationMarker);
    myLocationMarker = null;
  }

  final symbol = await mapController.addCircle(
    CircleOptions(
      geometry: location,
      circleRadius: 8,
      circleColor: "#0000FF",
      circleStrokeColor: "#FFFFFF",
      circleStrokeWidth: 4,
    ),
  );

  myLocationMarker = symbol;
}
