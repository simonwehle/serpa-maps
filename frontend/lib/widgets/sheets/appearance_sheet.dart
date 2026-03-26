import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/preferences/theme_mode_provider.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class AppearanceSheet extends ConsumerWidget {
  const AppearanceSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final themeModes = [ThemeMode.system, ThemeMode.light, ThemeMode.dark];
    final themeMode = ref.watch(themeModeProvider);
    final isSelected = themeModes.map((m) => m == themeMode).toList();

    return SerpaStaticSheet(
      title: "Appearance",
      child: ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (index) {
          ref
              .read(themeModeProvider.notifier)
              .updateThemeMode(themeModes[index]);
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: colorScheme.primary,
        selectedColor: colorScheme.surface,
        fillColor: colorScheme.primary,
        color: colorScheme.primary,
        constraints: const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
        isSelected: isSelected,
        children: const [Text('System'), Text('Light'), Text('Dark')],
      ),
    );
  }
}
