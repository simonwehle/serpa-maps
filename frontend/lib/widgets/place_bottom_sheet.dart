import 'package:flutter/material.dart';
import '../models/place.dart';
import '../models/category.dart';

class PlaceBottomSheet extends StatelessWidget {
  final Place place;
  final Category category;
  final String baseUrl;

  const PlaceBottomSheet({
    super.key,
    required this.place,
    required this.category,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            print('Share button pressed');
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // Material(
                        //   color: Colors.white,
                        //   child: Center(
                        //     child: Ink(
                        //       decoration: const ShapeDecoration(
                        //         color: Colors.lightBlue,
                        //         shape: CircleBorder(),
                        //       ),
                        //       child: IconButton(
                        //         icon: Icon(Icons.close),
                        //         onPressed: () {
                        //           Navigator.pop(context);
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  place.description?.isNotEmpty == true
                      ? place.description!
                      : "Keine Beschreibung verfügbar.",
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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

              const SizedBox(height: 16),

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
          ),
        );
      },
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
      case 'location_on':
      default:
        return Icons.location_on;
    }
  }
}
