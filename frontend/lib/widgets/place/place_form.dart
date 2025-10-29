import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/utils/extract_gps.dart';
import 'package:serpa_maps/widgets/place/place_assets.dart';

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
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownMenu<Category>(
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
              Container(padding: EdgeInsets.all(8)),
              Container(
                height: 56.0,
                width: 56.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: IconButton(
                  icon: const Icon(Symbols.forms_add_on),
                  onPressed: () => print("Button Pressed"),
                ),
              ),
            ],
          ),
        ),
        if (place != null) ...[
          PlaceAssets(place: place!),
          if (place!.assets.isNotEmpty) const SizedBox(height: 16),
        ],
        if (place == null)
          Center(
            child: Container(
              height: 56.0,
              width: 56.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.add_a_photo),
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
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: descriptionController,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Beschreibung',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Latitude',
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Longitude',
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
              onPressed: deletePlace != null
                  ? () async {
                      try {
                        await deletePlace!();
                        print('Place deleted!');
                      } catch (e) {
                        print('Fehler beim Löschen: $e');
                      }
                    }
                  : null,
              child: const Text('Delete Place'),
            ),
          ),
      ],
    );
  }
}
