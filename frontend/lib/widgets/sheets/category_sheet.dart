import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/models/category.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/utils/icon_color_utils.dart';
import 'package:serpa_maps/widgets/category/category_sheet_icon.dart';
import 'package:serpa_maps/widgets/sheets/category_menu_sheet.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class CategorySheet extends ConsumerWidget {
  const CategorySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final i10n = AppLocalizations.of(context)!;
    return categoriesAsync.when(
      data: (categories) {
        final allCategories = [
          ...categories,
          Category(
            id: 0,
            name: i10n.newCategory,
            icon: 'add',
            color: colorToHex(Theme.of(context).colorScheme.primary),
          ),
        ];
        return SerpaStaticSheet(
          title: i10n.categories,
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: allCategories
                .map(
                  (category) => GestureDetector(
                    onTap: () {
                      // Extract category id to edit; if id==0 create new category
                      showSerpaStaticSheet(
                        context: context,
                        child: CategoryMenuSheet(category: category),
                      );
                    },
                    child: CategorySheetIcon(category: category),
                  ),
                )
                .toList(),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
