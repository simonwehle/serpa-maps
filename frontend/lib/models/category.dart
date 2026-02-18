import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';

class Category {
  final int id;
  final String name;
  final String icon;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['category_id'],
    name: json['name'],
    icon: json['icon'],
    color: json['color'],
  );

  static Category dummyCategory(BuildContext context) {
    final i10n = Localizations.of(context, AppLocalizations)!;
    return Category(
      id: 0,
      name: i10n.newCategory,
      icon: 'add',
      color: colorToHex(Theme.of(context).colorScheme.primary),
    );
  }
}
