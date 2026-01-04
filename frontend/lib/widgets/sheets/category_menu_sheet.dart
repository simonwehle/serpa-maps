import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/widgets/form/serpa_divider.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';

class CategoryMenuSheet extends StatefulWidget {
  final Category category;
  const CategoryMenuSheet({super.key, required this.category});

  @override
  State<CategoryMenuSheet> createState() => _CategoryMenuSheetState();
}

class _CategoryMenuSheetState extends State<CategoryMenuSheet> {
  late TextEditingController nameController;
  IconData selectedIcon = Icons.location_pin;
  Color selectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    final icons = iconMap.values.toList();
    return SerpaStaticSheet(
      title: "Category Menu",
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: i10n.name,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: icons
                .map(
                  (icon) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedColor,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Icon(icon, size: 32, color: Colors.white),
                  ),
                )
                .toList(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SerpaDivider(indent: 4, endIndent: 4),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availableColors
                  .map(
                    (color) => Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          PlaceFormActions(
            onCancel: () => Navigator.pop(context),
            onSave: () {},
          ),
        ],
      ),
    );
  }
}
