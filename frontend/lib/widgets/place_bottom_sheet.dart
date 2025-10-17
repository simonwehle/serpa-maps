import 'package:flutter/material.dart';
import '../models/place.dart';
import '../models/category.dart';
import '../services/api_service.dart';

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
  _PlaceBottomSheetState createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends State<PlaceBottomSheet> {
  late bool isEditing;
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    isEditing = false;
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
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                              });
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.pop(context);
                          },
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
                            : "Keine Beschreibung verfügbar.",
                      ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _colorFromHex(widget.category.color),
                      child: Icon(
                        _iconFromString(widget.category.icon),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.category.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.place.assets.isNotEmpty)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.place.assets.length,
                    itemBuilder: (context, index) {
                      final asset = widget.place.assets[index];
                      final url = asset.assetUrl;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${widget.baseUrl}/$url',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (isEditing)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              isEditing = false;
                              nameController.text = widget.place.name;
                              descriptionController.text =
                                  widget.place.description ?? '';
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() => isEditing = false);
                            try {
                              final updatedPlace = await widget.api.updatePlace(
                                widget.place.id,
                                name: nameController.text,
                                description: descriptionController.text,
                              );

                              setState(() {
                                widget.place.name = updatedPlace.name;
                                widget.place.description =
                                    updatedPlace.description;
                              });

                              Navigator.of(context).pop(updatedPlace);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Update fehlgeschlagen: $e'),
                                ),
                              );
                            }
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  IconData _iconFromString(String iconName) {
    switch (iconName) {
      case 'camera_alt':
        return Icons.camera_alt;
      case 'fort':
        return Icons.fort;
      case 'location_on':
      default:
        return Icons.location_on;
    }
  }
}
