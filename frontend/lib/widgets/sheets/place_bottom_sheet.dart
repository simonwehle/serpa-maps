import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/item_by_id_providers.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';
import 'package:serpa_maps/widgets/place/place_display.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/place/place_form.dart';

class PlaceBottomSheet extends ConsumerStatefulWidget {
  final int placeId;

  const PlaceBottomSheet({super.key, required this.placeId});

  @override
  ConsumerState<PlaceBottomSheet> createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends ConsumerState<PlaceBottomSheet> {
  bool isEditing = false;

  TextEditingController? nameController;
  TextEditingController? descriptionController;
  TextEditingController? latitudeController;
  TextEditingController? longitudeController;

  List<Category>? categories;
  Category? selectedCategory;

  bool controllersInitialized = false;

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void initializeControllers(
    Place place,
    List<Category> categories,
    Category currentCategory,
  ) {
    if (!controllersInitialized) {
      nameController = TextEditingController(text: place.name);
      descriptionController = TextEditingController(
        text: place.description ?? '',
      );
      latitudeController = TextEditingController(
        text: place.latitude.toString(),
      );
      longitudeController = TextEditingController(
        text: place.longitude.toString(),
      );

      categories = categories;
      selectedCategory = currentCategory;

      controllersInitialized = true;
    }
  }

  @override
  void dispose() {
    nameController?.dispose();
    descriptionController?.dispose();
    latitudeController?.dispose();
    longitudeController?.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(int placeId) async {
    try {
      final latitude = double.tryParse(latitudeController!.text);
      final longitude = double.tryParse(longitudeController!.text);

      if (latitude == null || longitude == null) {
        throw 'Invalid latitude or longitude values';
      }

      await ref
          .read(placeProvider.notifier)
          .updatePlace(
            id: placeId,
            name: nameController!.text,
            description: descriptionController!.text,
            latitude: latitude,
            longitude: longitude,
            categoryId: selectedCategory!.id,
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

  Future<void> _cancel(Place place) async {
    setState(() {
      nameController!.text = place.name;
      descriptionController!.text = place.description ?? '';
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final place = ref.watch(placeByIdProvider(widget.placeId));
    final categoriesAsync = ref.watch(categoryProvider);
    if (place == null) return const Text('Place not found');

    final category = ref.watch(categoryByIdProvider(place.categoryId));
    if (category == null) return const Text('Category not found');

    return categoriesAsync.when(
      data: (categories) {
        final category = categories.firstWhereOrNull(
          (c) => c.id == place.categoryId,
        );
        if (category == null) return const Text('Category not found');

        initializeControllers(place, categories, category);

        return SerpaBottomSheet(
          bottomActions: isEditing
              ? PlaceFormActions(
                  onSave: () => _saveChanges(place.id),
                  onCancel: () => _cancel(place),
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
                  nameController: nameController!,
                  descriptionController: descriptionController!,
                  latitudeController: latitudeController!,
                  longitudeController: longitudeController!,
                  categories: categories,
                  selectedCategory: selectedCategory!,
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
                      Navigator.pop(context);
                    } catch (e) {
                      print('Fehler beim Löschen: $e');
                    }
                  },
                ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
