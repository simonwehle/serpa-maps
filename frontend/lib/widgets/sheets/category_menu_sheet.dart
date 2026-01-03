import 'package:flutter/material.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class CategoryMenuSheet extends StatefulWidget {
  final Category category;
  const CategoryMenuSheet({super.key, required this.category});

  @override
  State<CategoryMenuSheet> createState() => _CategoryMenuSheetState();
}

class _CategoryMenuSheetState extends State<CategoryMenuSheet> {
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return SerpaStaticSheet(
      title: widget.category.name,
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: i10n.name,
            ),
          ),
          const SizedBox(height: 16),
          PlaceFormActions(
            onCancel: () => Navigator.pop(context),
            onSave: () {},
          ),
        ],
      ),
    );
  }
}
