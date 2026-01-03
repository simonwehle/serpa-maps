import 'package:flutter/material.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/widgets/category/category_icon.dart';

class CategorySheetIcon extends StatelessWidget {
  final Category category;

  const CategorySheetIcon({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Stack(
            children: [
              CategoryIcon(size: 30, maxRadius: 25, category: category),
            ],
          ),
          const SizedBox(height: 8),
          Text(category.name, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
