import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/place_provider.dart';
import 'bottom_sheet.dart';
import '../models/category.dart';
import '../models/place.dart';
import './place/place_form.dart';
import './place/place_edit_form.dart';

class UploadBottomSheet extends ConsumerStatefulWidget {
  final List<Category> categories;

  const UploadBottomSheet({super.key, required this.categories});

  @override
  ConsumerState<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends ConsumerState<UploadBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  Place? place;

  late List<Category> categories;
  late Category selectedCategory;
  late String baseUrl;

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
    categories = widget.categories;

    selectedCategory = categories.first;
    baseUrl = dotenv.env['BASE_URL'] ?? "http://localhost:3465";
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
            categoryId: selectedCategory.id,
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
    return SerpaBottomSheet(
      bottomActions: PlaceEditForm(
        onCancel: () => Navigator.pop(context),
        isNew: true,
        onSave: _saveChanges,
      ),
      child: PlaceForm(
        baseUrl: baseUrl,
        categories: categories,
        selectedCategory: selectedCategory,
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
  }
}
