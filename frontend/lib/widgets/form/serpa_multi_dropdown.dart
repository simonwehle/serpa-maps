import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

class SerpaMultiDropdown extends StatelessWidget {
  final List<DropdownItem<String>> items;
  final void Function(List<String>)? onSelectionChange;

  const SerpaMultiDropdown({
    super.key,
    required this.items,
    this.onSelectionChange,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = Localizations.of(context, AppLocalizations)!;
    return MultiDropdown<String>(
      chipDecoration: ChipDecoration(
        backgroundColor: colorScheme.surfaceContainer,
        labelStyle: Theme.of(context).textTheme.bodySmall,
        spacing: 6,
        runSpacing: 6,
      ),
      dropdownDecoration: DropdownDecoration(
        backgroundColor: colorScheme.surfaceContainer,
        expandDirection: ExpandDirection.down,
        listPadding: const EdgeInsets.symmetric(vertical: 8),
        //backgroundColor: colorScheme.primary,
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedBackgroundColor: colorScheme.surfaceContainerHighest,
      ),
      fieldDecoration: FieldDecoration(
        hintText: l10n.addPlaceToGroup,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: items,
      onSelectionChange: onSelectionChange,
    );
  }
}
