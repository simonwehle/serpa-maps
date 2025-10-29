import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/item_by_id_providers.dart';
import 'package:serpa_maps/providers/map_markers_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/widgets/bottom_sheet.dart';
import 'package:serpa_maps/widgets/place/place_display.dart';
import 'package:serpa_maps/widgets/place/place_edit_form.dart';
import 'package:serpa_maps/widgets/place/place_form.dart';

class PlaceBottomSheet extends ConsumerStatefulWidget {
  final Place place;
  final Category category;
  final List<Category> categories;
  final int placeId;

  const PlaceBottomSheet({
    super.key,
    required this.place,
    required this.category,
    required this.categories,
    required this.placeId,
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

  Future<void> _saveChanges(int placeId) async {
    try {
      final latitude = double.tryParse(latitudeController.text);
      final longitude = double.tryParse(longitudeController.text);

      if (latitude == null || longitude == null) {
        throw 'Invalid latitude or longitude values';
      }

      await ref
          .read(placeProvider.notifier)
          .updatePlace(
            id: placeId,
            name: nameController.text,
            description: descriptionController.text,
            latitude: double.parse(latitudeController.text),
            longitude: double.parse(longitudeController.text),
            categoryId: selectedCategory.id,
          );
      toggleEditing();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  Future<void> _cancel(String placeName, String? placeDescription) async {
    setState(() {
      nameController.text = placeName;
      descriptionController.text = placeDescription ?? '';
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final place = ref.watch(placeByIdProvider(widget.placeId));
    if (place == null) return Text('Place not found');
    final category = ref.watch(categoryByIdProvider(place.categoryId));
    if (category == null) return Text('Category not found');
    return SerpaBottomSheet(
      bottomActions: isEditing
          ? PlaceEditForm(
              onSave: () {
                _saveChanges(place.id);
              },
              onCancel: () {
                _cancel(place.name, place.description);
              },
            )
          : null,
      child: !isEditing
          ? PlaceDisplay(
              toggleEditing: toggleEditing,
              category: category,
              place: place,
            )
          : PlaceForm(
              place: place,
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
                      .deletePlace(id: place.id);
                  await ref
                      .read(mapMarkersProvider.notifier)
                      .deletePlaceMarker(place.id);
                  ref.invalidate(placeProvider);
                  Navigator.pop(context);
                } catch (e) {
                  print('Fehler beim Löschen: $e');
                }
              },
            ),
    );
  }
}
