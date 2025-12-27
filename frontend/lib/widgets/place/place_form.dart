import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/utils/dialogs.dart';
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

  void _normalizeDecimalInput(TextEditingController controller, String value) {
    String normalizedValue = value.replaceAll(',', '.');
    double? parsed = double.tryParse(normalizedValue);
    if (parsed != null && normalizedValue != value) {
      controller.value = controller.value.copyWith(
        text: normalizedValue,
        selection: TextSelection.collapsed(offset: normalizedValue.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: i10n.name,
            ),
          ),
          const SizedBox(height: 16),
          Row(
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
                onPressed: () => print("Category Button Pressed"),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: PlaceAssets(
              assets: place?.assets ?? [],
              isEditing: true,
              onAddImage: () async {
                final picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (image != null) {
                  final gps = await extractGpsFromImage(image);
                  if (gps != null &&
                      latitudeController.text.isEmpty &&
                      longitudeController.text.isEmpty) {
                    latitudeController.text = gps.$1.toString();
                    longitudeController.text = gps.$2.toString();
                  }
                }
              },
            ),
          ),
          TextField(
            controller: descriptionController,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: i10n.description,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: latitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: i10n.latitude,
                  ),
                  onChanged: (value) =>
                      _normalizeDecimalInput(latitudeController, value),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: longitudeController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: i10n.longitude,
                  ),
                  onChanged: (value) =>
                      _normalizeDecimalInput(longitudeController, value),
                ),
              ),
            ],
          ),
          if (deletePlace != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.red),
                ),
                onPressed: () async {
                  final confirmed = await showDeleteConfirmationDialog(
                    context,
                    title: i10n.deletePlace,
                    message: i10n.deletePlaceQuestion,
                  );
                  if (confirmed && deletePlace != null) {
                    await deletePlace!();
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: Text(i10n.deletePlace),
              ),
            ),
        ],
      ),
    );
  }
}
