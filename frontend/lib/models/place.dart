import 'package:serpa_maps/models/asset.dart';

class Place {
  final int id;
  String name;
  String? description;
  double latitude;
  double longitude;
  int categoryId;
  final DateTime createdAt;
  List<Asset> assets;

  Place({
    required this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
    required this.assets,
    required this.createdAt,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['place_id'],
    name: json['name'],
    description: json['description'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    categoryId: json['category_id'],
    createdAt: DateTime.parse(json['created_at']),
    assets: (json['assets'] as List).map((e) => Asset.fromJson(e)).toList(),
  );
}
