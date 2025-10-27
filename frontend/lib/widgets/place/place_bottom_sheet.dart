import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/widgets/bottom_sheet.dart';
import 'package:serpa_maps/widgets/place/place_display.dart';
import 'package:serpa_maps/widgets/place/place_edit_form.dart';
import 'package:serpa_maps/widgets/place/place_form.dart';

class PlaceBottomSheet extends ConsumerStatefulWidget {
  final Place place;
  final Category category;
  final List<Category> categories;
  final String baseUrl;

  const PlaceBottomSheet({
    super.key,
    required this.place,
    required this.category,
    required this.categories,
    required this.baseUrl,
  });

  @override
  ConsumerState<PlaceBottomSheet> createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends ConsumerState<PlaceBottomSheet> {
  bool isEditing = false;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  late List<Category> categories;
  late Category selectedCategory;

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.place.name);
    descriptionController = TextEditingController(
      text: widget.place.description,
    );
    latitudeController = TextEditingController(
      text: widget.place.latitude.toString(),
    );
    longitudeController = TextEditingController(
      text: widget.place.longitude.toString(),
    );
    categories = widget.categories;

    selectedCategory = widget.category;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      final latitude = double.tryParse(latitudeController.text);
      final longitude = double.tryParse(longitudeController.text);

      if (latitude == null || longitude == null) {
        throw 'Invalid latitude or longitude values';
      }

      await ref
          .read(placeProvider.notifier)
          .updatePlace(
            id: widget.place.id,
            name: nameController.text,
            description: descriptionController.text,
            latitude: double.parse(latitudeController.text),
            longitude: double.parse(longitudeController.text),
            categoryId: selectedCategory.id,
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  Future<void> _cancel() async {
    setState(() {
      nameController.text = widget.place.name;
      descriptionController.text = widget.place.description ?? '';
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SerpaBottomSheet(
      bottomActions: isEditing
          ? PlaceEditForm(onSave: _saveChanges, onCancel: _cancel)
          : null,
      child: !isEditing
          ? PlaceDisplay(
              place: widget.place,
              category: selectedCategory,
              baseUrl: widget.baseUrl,
              toggleEditing: toggleEditing,
            )
          : PlaceForm(
              place: widget.place,
              baseUrl: widget.baseUrl,
              nameController: nameController,
              descriptionController: descriptionController,
              latitudeController: latitudeController,
              longitudeController: longitudeController,
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (Category? newCategory) {
                setState(() {
                  selectedCategory = newCategory!;
                });
              },
              deletePlace: () async {
                try {
                  await ref
                      .read(placeProvider.notifier)
                      .deletePlace(id: widget.place.categoryId);
                  ref.invalidate(placeProvider);
                  print('Place deleted!');
                } catch (e) {
                  print('Fehler beim Löschen: $e');
                }
              },
            ),
    );
  }
}
