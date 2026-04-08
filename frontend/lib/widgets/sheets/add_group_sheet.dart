import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/providers/data/group_provider.dart';
import 'package:serpa_maps/widgets/form/form_text_field.dart';
import 'package:serpa_maps/widgets/place/place_form_actions.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class AddGroupBottomSheet extends ConsumerStatefulWidget {
  const AddGroupBottomSheet({super.key});

  @override
  ConsumerState<AddGroupBottomSheet> createState() =>
      _AddGroupBottomSheetState();
}

class _AddGroupBottomSheetState extends ConsumerState<AddGroupBottomSheet> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return SerpaStaticSheet(
      title: i10n.addGroup,
      child: Column(
        children: [
          FormTextField(label: i10n.name, controller: nameController),
          const SizedBox(height: 16),
          FormTextField(
            label: i10n.description,
            controller: descriptionController,
            optional: true,
          ),
          const SizedBox(height: 16),
          PlaceFormActions(
            onCancel: () => Navigator.pop(context),
            onSave: () {
              ref
                  .read(groupProvider.notifier)
                  .addGroup(
                    name: nameController.text,
                    description: descriptionController.text,
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
