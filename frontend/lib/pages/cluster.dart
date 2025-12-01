import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class ClusterMap extends StatefulWidget {
  const ClusterMap({super.key});

  @override
  State<ClusterMap> createState() => _ClusterMapState();
}

class _ClusterMapState extends State<ClusterMap> {
  late MapLibreMapController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapLibreMap(
        styleString: "https://tiles.openfreemap.org/styles/liberty",
        onMapCreated: (c) => controller = c,
        onStyleLoadedCallback: _onStyleLoaded,
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 10,
        ),
      ),
    );
  }

  Future<void> _onStyleLoaded() async {
    // Hard-coded markers
    final points = {
      "type": "FeatureCollection",
      "features": [
        pt(-122.4194, 37.7749), // downtown SF
        pt(-122.4189, 37.7752),
        pt(-122.4190, 37.7755),
        pt(-122.4185, 37.7745),
        pt(-122.4175, 37.7750),
        pt(-122.4170, 37.7748),
        pt(-122.4165, 37.7753),
        pt(-122.4155, 37.7749),
        pt(-122.4145, 37.7752),
        pt(-122.4140, 37.7746),
      ],
    };

    // Add clustered source
    await controller.addSource(
      "places",
      GeojsonSourceProperties(
        data: points,
        cluster: true,
        clusterMaxZoom: 14,
        clusterRadius: 60,
      ),
    );

    // Big cluster circle
    await controller.addCircleLayer(
      "places",
      "cluster-circles",
      const CircleLayerProperties(
        circleColor: "#FF5722",
        circleRadius: 25,
        circleStrokeWidth: 3,
        circleStrokeColor: "#ffffff",
      ),
      filter: ["has", "point_count"],
    );

    // Cluster number label
    await controller.addSymbolLayer(
      "places",
      "cluster-count",
      const SymbolLayerProperties(
        textField: ["get", "point_count"],
        textSize: 14,
        textColor: "#ffffff",
        textIgnorePlacement: true,
        textAllowOverlap: true,
      ),
      filter: ["has", "point_count"],
    );

    // Non-clustered points
    await controller.addCircleLayer(
      "places",
      "unclustered-points",
      const CircleLayerProperties(
        circleColor: "#2196F3",
        circleRadius: 8,
        circleStrokeWidth: 2,
        circleStrokeColor: "#ffffff",
      ),
      filter: [
        "!",
        ["has", "point_count"],
      ],
    );
  }

  Map<String, dynamic> pt(double lon, double lat) {
    return {
      "type": "Feature",
      "geometry": {
        "type": "Point",
        "coordinates": [lon, lat],
      },
    };
  }
}
