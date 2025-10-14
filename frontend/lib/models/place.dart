class Place {
  final int id;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final int categoryId;

  Place({
    required this.id,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.categoryId,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['place_id'],
    name: json['name'],
    description: json['description'],
    latitude: json['latitude'],
    longitude: json['longitude'],
    categoryId: json['category_id'],
  );
}
