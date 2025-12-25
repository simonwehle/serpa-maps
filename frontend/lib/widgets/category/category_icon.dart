import 'package:flutter/material.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';

class CategoryIcon extends StatelessWidget {
  final Category category;
  final double size;
  final double maxRadius;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 15.0,
    this.maxRadius = 12.5,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: colorFromHex(category.color),
      maxRadius: maxRadius,
      child: Icon(
        iconFromString(category.icon),
        color: Colors.white,
        size: size,
      ),
    );
  }
}
