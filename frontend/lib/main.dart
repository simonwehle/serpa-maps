import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'models/place.dart';
import 'models/category.dart';
import 'services/api_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serpa Maps',
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapLibreMapController? mapController;
  bool _bottomSheetOpen = false;
  List<Place> places = [];
  List<Category> categories = [];
  late final ApiService api;

  @override
  void initState() {
    super.initState();

    final baseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:3465";
    api = ApiService(baseUrl);

    _loadData();
  }

  Future<void> _loadData() async {
    categories = await api.fetchCategories();
    places = await api.fetchPlaces();
    if (mapController != null) {
      _addPlaceMarkers();
    }
    setState(() {});
  }

  Future<Uint8List> _createMarkerImage(
    IconData icon,
    Color color, {
    double size = 120,
    double iconSize = 70,
  }) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Paint paint = Paint()..color = color;
    final double radius = size / 2;
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: iconSize,
        fontFamily: icon.fontFamily,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(size.toInt(), size.toInt());
    final ByteData? pngBytes = await img.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return pngBytes!.buffer.asUint8List();
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    mapController = controller;
    await _addPlaceMarkers();
  }

  Future<void> _addPlaceMarkers() async {
    if (mapController == null) return;

    for (final place in places) {
      final category = categories.firstWhere(
        (c) => c.id == place.categoryId,
        orElse: () => Category(
          id: 0,
          name: "Unbekannt",
          icon: "location_on",
          color: "#999999",
        ),
      );
      final color = _colorFromHex(category.color);
      final iconData = _iconFromString(category.icon);

      final bytes = await _createMarkerImage(iconData, color);
      final markerId = 'place_${place.id}';
      await mapController!.addImage(markerId, bytes);

      final symbol = await mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(place.latitude, place.longitude),
          iconImage: markerId,
          iconSize: 0.6,
        ),
      );

      mapController!.onSymbolTapped.add((symbolTapped) {
        if (symbolTapped == symbol) {
          _showBottomSheet(place, category);
        }
      });
    }
  }

  void _showBottomSheet(Place place, Category category) {
    if (_bottomSheetOpen) return;

    _bottomSheetOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.2,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    place.description ?? "Keine Beschreibung verfügbar.",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).whenComplete(() => _bottomSheetOpen = false);
  }

  Color _colorFromHex(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse(hex, radix: 16));
  }

  IconData _iconFromString(String iconName) {
    const map = {
      "camera_alt": Icons.camera_alt,
      "fort": Icons.fort,
      "restaurant": Icons.restaurant,
      "location_on": Icons.location_on,
    };
    return map[iconName] ?? Icons.location_on;
  }

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env['API_KEY'];
    return Scaffold(
      body: MapLibreMap(
        styleString:
            "https://api.maptiler.com/maps/streets/style.json?key=$apiKey",
        initialCameraPosition: const CameraPosition(
          target: LatLng(49.0139, 8.4043),
          zoom: 15,
        ),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
