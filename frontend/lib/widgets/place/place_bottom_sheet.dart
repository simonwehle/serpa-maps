import 'package:flutter/material.dart';
import '../../../models/place.dart';
import '../../../models/category.dart';
import '../../../services/api_service.dart';
import 'place_form.dart';
import '../bottom_sheet.dart';
import 'place_display.dart';
import 'place_edit_form.dart';

class PlaceBottomSheet extends StatefulWidget {
  final Place place;
  final Category category;
  final List<Category> categories;
  final String baseUrl;
  final ApiService api;

  const PlaceBottomSheet({
    super.key,
    required this.place,
    required this.category,
    required this.categories,
    required this.baseUrl,
    required this.api,
  });

  @override
  State<PlaceBottomSheet> createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends State<PlaceBottomSheet> {
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

      final updatedPlace = await widget.api.updatePlace(
        widget.place.id,
        name: nameController.text,
        description: descriptionController.text,
        categoryId: selectedCategory.id,
        latitude: latitude,
        longitude: longitude,
      );

      setState(() {
        widget.place.name = updatedPlace.name;
        widget.place.description = updatedPlace.description;
        widget.place.assets = updatedPlace.assets;
        widget.place.categoryId = selectedCategory.id;
        widget.place.latitude = updatedPlace.latitude;
        widget.place.longitude = updatedPlace.longitude;
        isEditing = false;
      });

      if (mounted) Navigator.of(context).pop(updatedPlace);
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
                  await widget.api.deletePlace(id: widget.place.categoryId);
                  print('Place deleted!');
                } catch (e) {
                  print('Fehler beim Löschen: $e');
                }
              },
            ),
    );
  }
}
