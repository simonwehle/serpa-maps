import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/widgets/category/category_icon.dart';
import 'package:serpa_maps/widgets/sheets/serpa_static_sheet.dart';

class CategorySheet extends ConsumerWidget {
  const CategorySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final i10n = AppLocalizations.of(context)!;
    return categoriesAsync.when(
      data: (categories) {
        return SerpaStaticSheet(
          title: i10n.categories,
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: [
              ...categories.map(
                (category) => SizedBox(
                  width: 100,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CategoryIcon(
                            size: 30,
                            maxRadius: 25,
                            category: category,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        //style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        minimumSize: const Size(60, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(0),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.add),
                      label: Text(i10n.newCategory),
                      onPressed: () {
                        // TODO: Implement new category action
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
