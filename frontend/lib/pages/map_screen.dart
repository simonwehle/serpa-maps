import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/location_permission_provider.dart';
import 'package:serpa_maps/providers/markers_visible_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/services/place_service.dart';
import 'package:serpa_maps/widgets/map/layer_button.dart';
import 'package:serpa_maps/widgets/map/serpa_fab.dart';
import 'package:serpa_maps/widgets/sheets/add_place_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/place_bottom_sheet.dart';
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
  bool _mapReady = false;
  bool _sourceAdded = false;

  void openAddPlaceBottomSheet({double? latitude, double? longitude}) {
    showSerpaDraggableSheet(
      context: context,
      child: AddPlaceBottomSheet(latitude: latitude, longitude: longitude),
    );
  }

  void openPlaceBottomSheet({required int placeId}) {
    showSerpaDraggableSheet(
      context: context,
      child: PlaceBottomSheet(placeId: placeId),
    );
  }

  void openLayerBottomSheet() {
    showSerpaStaticSheet(context: context, child: LayerBottomSheet());
  }

  Future addMarkerImage() async {
    final defaultIcon = createMarkerImage(Icons.gps_fixed, Colors.red);
    final sightIcon = createMarkerImage(Icons.camera_alt, Colors.purple);
    final fortIcon = createMarkerImage(Icons.fort, Colors.yellowAccent);

    await _controller.addImage("default-marker", await defaultIcon);
    await _controller.addImage("1", await sightIcon);
    await _controller.addImage("2", await fortIcon);
  }

  Future<void> _updatePlacesSource(List<Place>? places) async {
    if (!_mapReady) return;

    final placesGeoJson = {
      "type": "FeatureCollection",
      "features":
          places?.map((place) {
            return {
              "type": "Feature",
              "id": place.id,
              "properties": {"categoryId": place.categoryId},
              "geometry": {
                "type": "Point",
                "coordinates": [place.longitude, place.latitude],
              },
            };
          }).toList() ??
          [],
    };

    if (!_sourceAdded) {
      await _controller.addSource(
        "places",
        GeojsonSourceProperties(data: placesGeoJson),
      );
      _sourceAdded = true;
    } else {
      await _controller.setGeoJsonSource("places", placesGeoJson);
    }
  }

  Future<void> _addPlaceLayer() async {
    await _controller.addSymbolLayer(
      "places", // source id
      "places-layer", // layer id
      const SymbolLayerProperties(
        iconImage: [
          'match',
          ['get', 'categoryId'],
          1,
          '1',
          2,
          '2',
          'default-marker', // fallback
        ],
        iconSize: 0.5,
      ),
      enableInteraction: true,
    );
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    _controller = controller;
    setState(() {
      _mapReady = true;
    });

    await addMarkerImage();

    await _updatePlacesSource(ref.read(placeProvider).value);

    await _addPlaceLayer();

    controller.onFeatureTapped.add(onFeatureTap);
  }

  void onFeatureTap(
    Point<double> point,
    LatLng latLng,
    String id,
    String layerId,
    Annotation? annotation,
  ) {
    openPlaceBottomSheet(placeId: int.parse(id));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(placeProvider, (previous, next) {
      _updatePlacesSource(next.value);
    });

    return Scaffold(
      body: Stack(
        children: [
          MapLibreMap(
            styleString: 'http://localhost:3465/styles/liberty.json',
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            //trackCameraPosition: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(43.7383, 7.4248),
              zoom: 13,
            ),
            onMapLongClick: (point, latLng) {
              openAddPlaceBottomSheet(
                latitude: latLng.latitude,
                longitude: latLng.longitude,
              );
            },
            attributionButtonPosition: AttributionButtonPosition.bottomLeft,
          ),
          LayerButton(onPressed: openLayerBottomSheet),
        ],
      ),
      floatingActionButton: !_mapReady
          ? null
          : SerpaFab(
              mapController: _controller,
              openAddPlaceBottomSheet: openAddPlaceBottomSheet,
            ),
    );
  }
}
