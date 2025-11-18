import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/utils/extract_gps.dart';
import 'package:serpa_maps/widgets/place/place_assets.dart';
import 'package:serpa_maps/widgets/place/place_form_button.dart';

class PlaceForm extends StatelessWidget {
  final Place? place;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final List<Category> categories;
  final Category selectedCategory;
  final ValueChanged<Category?> onCategorySelected;
  final Future<void> Function()? deletePlace;

  const PlaceForm({
    super.key,
    this.place,
    required this.nameController,
    required this.descriptionController,
    required this.latitudeController,
    required this.longitudeController,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.deletePlace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.name,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownMenu<Category>(
                  width:
                      MediaQuery.of(context).size.width - 56.0 - 8.0 - 2 * 16.0,
                  initialSelection: selectedCategory,
                  onSelected: (Category? newCategory) {
                    onCategorySelected(newCategory);
                  },
                  dropdownMenuEntries: categories.map((Category category) {
                    return DropdownMenuEntry<Category>(
                      value: category,
                      label: category.name,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 8),
              PlaceFormButton(
                icon: Symbols.forms_add_on,
                onPressed: () => print("Button Pressed"),
              ),
            ],
          ),
        ),
        if (place != null) ...[
          PlaceAssets(assets: place!.assets),
          if (place!.assets.isNotEmpty) const SizedBox(height: 16),
        ],
        if (place == null)
          Center(
            child: PlaceFormButton(
              icon: Icons.add_a_photo,
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  final gps = await extractGpsFromImage(image);
                  if (gps != null) {
                    latitudeController.text = gps.$1.toString();
                    longitudeController.text = gps.$2.toString();
                  }
                }
              },
            ),
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: descriptionController,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.description,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: latitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.latitude,
                  ),
                  onChanged: (value) {
                    double? latitude = double.tryParse(value);
                    if (latitude != null) {
                    } else {}
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: longitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.longitude,
                  ),
                  onChanged: (value) {
                    double? longitude = double.tryParse(value);
                    if (longitude != null) {
                    } else {}
                  },
                ),
              ),
            ],
          ),
        ),
        if (deletePlace != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
              ),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.deletePlace),
                  content: Text(
                    AppLocalizations.of(context)!.deletePlaceQuestion,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (deletePlace != null) await deletePlace!();
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.yes),
                    ),
                  ],
                ),
              ),
              child: Text(AppLocalizations.of(context)!.deletePlace),
            ),
          ),
      ],
    );
  }
}
