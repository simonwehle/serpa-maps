import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'models/place.dart';
import 'models/category.dart';
import 'services/api_service.dart';
import 'services/place_service.dart';
import 'widgets/place_bottom_sheet.dart';

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
  List<Place> places = [];
  List<Category> categories = [];
  late final ApiService api;
  late String baseUrl;
  final placeService = PlaceService();
  bool _bottomSheetOpen = false;

  final Map<String, Map<String, dynamic>> _symbolData = {};

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:3465";
    api = ApiService(baseUrl);
    _loadData();
  }

  Future<void> _loadData() async {
    categories = await api.fetchCategories();
    places = await api.fetchPlaces();
    if (mapController != null) {
      await _addPlaceMarkers();
    }
    setState(() {});
  }

  Future<void> _onMapCreated(MapLibreMapController controller) async {
    mapController = controller;
    await _addPlaceMarkers();
  }

  Future<void> _addPlaceMarkers() async {
    if (mapController == null) return;

    _symbolData.clear();
    mapController!.onSymbolTapped.clear();

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

      final bytes = await placeService.createMarkerImage(
        placeService.iconFromString(category.icon),
        placeService.colorFromHex(category.color),
      );

      final markerId = 'place_${place.id}';
      await mapController!.addImage(markerId, bytes);

      final symbol = await mapController!.addSymbol(
        SymbolOptions(
          geometry: LatLng(place.latitude, place.longitude),
          iconImage: markerId,
          iconSize: 0.6,
        ),
      );

      _symbolData[symbol.id] = {'place': place, 'category': category};
    }

    mapController!.onSymbolTapped.add((symbol) {
      final data = _symbolData[symbol.id];
      if (data != null) {
        _showBottomSheet(data['place'], data['category']);
      }
    });
  }

  void _showBottomSheet(Place place, Category category) {
    if (_bottomSheetOpen) return;

    _bottomSheetOpen = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlaceBottomSheet(place: place, category: category),
    ).whenComplete(() => _bottomSheetOpen = false);
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
