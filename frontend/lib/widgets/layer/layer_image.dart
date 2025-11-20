import 'package:flutter/material.dart';

class LayerImage extends StatelessWidget {
  final AssetImage assetImage;
  final String name;
  final double? height;
  final double? width;
  final double? radius;
  const LayerImage({
    super.key,
    required this.assetImage,
    required this.name,
    this.height = 100,
    this.width = 100,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius!),
          border: Border.all(color: Colors.grey),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius!),
          child: Stack(
            children: [
              Image(image: assetImage, width: width, height: height),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  color: Colors.black.withValues(alpha: 0.4),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
