import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/layer/serpa_selector.dart';

class LayerImage extends StatelessWidget {
  final AssetImage assetImage;
  final String name;
  final double? height;
  final double? width;
  final double? radius;
  final bool isActive;
  final VoidCallback? onTap;

  const LayerImage({
    super.key,
    required this.assetImage,
    required this.name,
    this.height = 90,
    this.width = 90,
    this.radius = 20,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double borderWidth = 4;
    final double innerPadding = 3;
    return SerpaSelector(
      isActive: isActive,
      radius: 20,
      borderWidth: borderWidth,
      innerPadding: innerPadding,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          radius! - borderWidth - innerPadding,
        ),
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
    );
  }
}
