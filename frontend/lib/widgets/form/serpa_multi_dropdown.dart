import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class SerpaMultiDropdown extends StatelessWidget {
  final List<DropdownItem<String>> items;
  const SerpaMultiDropdown({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
        listPadding: EdgeInsets.symmetric(vertical: 8),
        //backgroundColor: colorScheme.primary,
      ),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedBackgroundColor: colorScheme.surfaceContainerHighest,
      ),
      fieldDecoration: FieldDecoration(
        hintText: 'Add place to group',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: items,
      onSelectionChange: (selectedItems) {},
    );
  }
}
