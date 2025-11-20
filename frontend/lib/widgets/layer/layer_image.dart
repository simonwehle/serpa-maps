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
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius!),
            border: Border.all(color: Colors.grey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: Image(image: assetImage, width: width, height: height),
          ),
        ),
        Text(name),
      ],
    );
  }
}
