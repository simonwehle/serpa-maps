import 'package:flutter/material.dart';
import '../../models/place.dart';
import '../../models/category.dart';

class PlaceDetails extends StatelessWidget {
  final Place place;
  final Category category;
  final String baseUrl;

  const PlaceDetails({
    super.key,
    required this.place,
    required this.category,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: _colorFromHex(category.color),
                child: Icon(
                  _iconFromString(category.icon),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        if (place.assets.isNotEmpty)
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: place.assets.length,
              itemBuilder: (context, index) {
                final asset = place.assets[index];
                final url = asset.assetUrl;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '$baseUrl/$url',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'camera_alt':
        return Icons.camera_alt;
      case 'fort':
        return Icons.fort;
      default:
        return Icons.location_on;
    }
  }
}
