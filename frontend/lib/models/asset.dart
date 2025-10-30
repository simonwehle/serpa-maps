class Asset {
  final int assetId;
  final int placeId;
  final String assetUrl;
  final String assetType;
  final int position;
  final DateTime createdAt;

  Asset({
    required this.assetId,
    required this.placeId,
    required this.assetUrl,
    required this.assetType,
    required this.position,
    required this.createdAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    assetId: json['asset_id'],
    placeId: json['place_id'],
    assetUrl: json['asset_url'],
    assetType: json['asset_type'],
    position: json['position'],
    createdAt: DateTime.parse(json['created_at']),
  );
}
