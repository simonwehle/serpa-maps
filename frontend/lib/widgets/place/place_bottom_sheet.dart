import 'package:flutter/material.dart';
import '../../../models/place.dart';
import '../../../models/category.dart';
import '../../../services/api_service.dart';
import 'place_details.dart';
import 'place_edit_form.dart';

class PlaceBottomSheet extends StatefulWidget {
  final Place place;
  final Category category;
  final String baseUrl;
  final ApiService api;

  const PlaceBottomSheet({
    super.key,
    required this.place,
    required this.category,
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.place.name);
    descriptionController = TextEditingController(
      text: widget.place.description,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      final updatedPlace = await widget.api.updatePlace(
        widget.place.id,
        name: nameController.text,
        description: descriptionController.text,
      );

      setState(() {
        widget.place.name = updatedPlace.name;
        widget.place.description = updatedPlace.description;
        widget.place.assets = updatedPlace.assets;
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

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.2,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isEditing
                        ? Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          )
                        : Text(
                            widget.place.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    Row(
                      children: [
                        if (!isEditing)
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => setState(() => isEditing = true),
                          ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: isEditing
                    ? TextField(
                        controller: descriptionController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Beschreibung',
                        ),
                      )
                    : Text(
                        widget.place.description?.isNotEmpty == true
                            ? widget.place.description!
                            : 'Keine Beschreibung verfügbar.',
                      ),
              ),
              const SizedBox(height: 16),
              PlaceDetails(
                place: widget.place,
                category: widget.category,
                baseUrl: widget.baseUrl,
              ),
              if (isEditing)
                PlaceEditForm(
                  nameController: nameController,
                  descriptionController: descriptionController,
                  onCancel: () {
                    setState(() {
                      nameController.text = widget.place.name;
                      descriptionController.text =
                          widget.place.description ?? '';
                      isEditing = false;
                    });
                  },
                  onSave: _saveChanges,
                ),
            ],
          ),
        );
      },
    );
  }
}
