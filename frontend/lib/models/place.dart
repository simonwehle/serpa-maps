class Asset {
  final int assetId;
  final int placeId;
  final String assetUrl;
  final String assetType;

  Asset({
    required this.assetId,
    required this.placeId,
    required this.assetUrl,
    required this.assetType,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    assetId: json['asset_id'],
    placeId: json['place_id'],
    assetUrl: json['asset_url'],
    assetType: json['asset_type'],
  );
}

class Place {
  final int id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final int categoryId;
  final List<Asset> assets;

  Place({
    required this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
    required this.assets,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['place_id'],
    name: json['name'],
    description: json['description'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    categoryId: json['category_id'],
    assets: (json['assets'] as List).map((e) => Asset.fromJson(e)).toList(),
  );
}
