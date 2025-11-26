import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:latlong2/latlong.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/location_permission_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/utils/adaptive_max_zoom.dart';
import 'package:serpa_maps/widgets/map/layer_button.dart';
import 'package:serpa_maps/widgets/map/serpa_fab.dart';
import 'package:serpa_maps/widgets/map/place_markers_layer.dart';
import 'package:serpa_maps/widgets/map/overlay_layer.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_draggable_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/widgets/sheets/layer_bottom_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});
  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late MapLibreMapController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addPlaceMarkers();
    });
  }

  void openAddPlaceBottomSheet({double? latitude, double? longitude}) {
    showSerpaDraggableSheet(
      context: context,
      child: AddPlaceBottomSheet(latitude: latitude, longitude: longitude),
    );
  }

  void openLayerBottomSheet() {
    showSerpaStaticSheet(context: context, child: LayerBottomSheet());
  }

  Future addMarkerImage() async {
    Uint8List bytes = await rootBundle
        .load('assets/location-pin.png')
        .then((b) => b.buffer.asUint8List());
    await _controller.addImage("marker-icon", bytes);
  }

  Future<void> addPlaceMarkers() async {
    final placesAsync = ref.read(placeProvider);

    if (placesAsync is! AsyncData) {
      return;
    }

    final places = placesAsync.value;

    final placesGeoJson = {
      "type": "FeatureCollection",
      "features": places?.map((place) {
        return {
          "type": "Feature",
          "properties": {"placeId": place.id},
          "geometry": {
            "type": "Point",
            "coordinates": [place.longitude, place.latitude],
          },
        };
      }).toList(),
    };

    await _controller.addSource(
      "places",
      GeojsonSourceProperties(data: placesGeoJson),
    );
  }

  Future<void> _addPlaceLayer() async {
    await _controller.addSymbolLayer(
      "places", // source id
      "places-layer", // layer id
      const SymbolLayerProperties(iconImage: "marker-icon", iconSize: 1.0),
    );
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    _controller = controller;

    await addMarkerImage();
    await addPlaceMarkers();
    await _addPlaceLayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLibreMap(
        styleString: 'http://localhost:3465/styles/liberty.json',
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(43.7383, 7.4248),
          zoom: 13,
        ),
      ),
    );
  }
}
