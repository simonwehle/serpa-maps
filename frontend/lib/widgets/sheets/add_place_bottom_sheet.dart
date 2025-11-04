import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/widgets/place/place_edit_form.dart';
import 'package:serpa_maps/widgets/place/place_form.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';

class AddPlaceBottomSheet extends ConsumerStatefulWidget {
  final double? latitude;
  final double? longitude;
  const AddPlaceBottomSheet({super.key, this.latitude, this.longitude});

  @override
  ConsumerState<AddPlaceBottomSheet> createState() =>
      _AddPlaceBottomSheetState();
}

class _AddPlaceBottomSheetState extends ConsumerState<AddPlaceBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late List<Category> categories;
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    latitudeController = TextEditingController(
      text: widget.latitude != null ? widget.latitude.toString() : '',
    );
    longitudeController = TextEditingController(
      text: widget.longitude != null ? widget.longitude.toString() : '',
    );

    //selectedCategory = categories.first;
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

      final addPlace = await ref
          .read(placeProvider.notifier)
          .addPlace(
            name: nameController.text,
            description: descriptionController.text,
            categoryId: selectedCategory!.id,
            latitude: latitude,
            longitude: longitude,
          );

      if (mounted && addPlace != null) {
        Navigator.of(context).pop(addPlace);
      } else {
        throw 'Failed to add place: Response was null';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Add place failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryProvider);
    return categories.when(
      data: (categories) {
        selectedCategory ??= categories.isNotEmpty ? categories.first : null;
        if (selectedCategory == null) {
          return Text('Keine Kategorien verfügbar');
        }
        return SerpaBottomSheet(
          bottomActions: PlaceEditForm(
            onCancel: () => Navigator.pop(context),
            isNew: true,
            onSave: _saveChanges,
          ),
          child: PlaceForm(
            categories: categories,
            selectedCategory: selectedCategory!,
            nameController: nameController,
            descriptionController: descriptionController,
            latitudeController: latitudeController,
            longitudeController: longitudeController,
            onCategorySelected: (Category? newCategory) {
              setState(() {
                selectedCategory = newCategory!;
              });
            },
          ),
        );
      },
      loading: () => CircularProgressIndicator(),
      error: (err, _) => Text('Fehler: $err'),
    );
  }
}
