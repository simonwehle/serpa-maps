import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

import 'package:serpa_maps/providers/place_provider.dart';
import 'package:serpa_maps/providers/category_provider.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/widgets/category/category_icon.dart';

class SerpaSearchBar extends ConsumerStatefulWidget {
  final Function(Place)? onPlaceSelected;

  const SerpaSearchBar({super.key, this.onPlaceSelected});

  @override
  ConsumerState<SerpaSearchBar> createState() => _SerpaSearchBarState();
}

class _SerpaSearchBarState extends ConsumerState<SerpaSearchBar> {
  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(placeProvider);
    final categoriesAsync = ref.watch(categoryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (isAndroid || isIOS) const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SearchAnchor(
            viewBackgroundColor: Theme.of(context).colorScheme.surface,
            isFullScreen: false,
            viewConstraints: const BoxConstraints(maxHeight: 275),
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.surface,
                ),
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                hintText: l10n.searchPlaces,
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
                trailing: <Widget>[const Icon(Icons.person)],
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  return placesAsync.when(
                    data: (places) {
                      final query = controller.text.toLowerCase();
                      final filteredPlaces = query.isEmpty
                          ? places
                          : places
                                .where(
                                  (place) =>
                                      place.name.toLowerCase().contains(query),
                                )
                                .toList();

                      if (filteredPlaces.isEmpty) {
                        return [
                          const ListTile(title: Text('No results found')),
                        ];
                      }

                      return filteredPlaces.map((place) {
                        final category = categoriesAsync.value?.firstWhere(
                          (cat) => cat.id == place.categoryId,
                          orElse: () => null as dynamic,
                        );

                        return ListTile(
                          leading: category != null
                              ? CategoryIcon(category: category)
                              : const Icon(Icons.place),
                          title: Text(place.name),
                          // subtitle: place.description != ""
                          //     ? Text(place.description!)
                          //     : null,
                          onTap: () {
                            controller.closeView(place.name);
                            widget.onPlaceSelected?.call(place);
                          },
                        );
                      }).toList();
                    },
                    loading: () => [
                      const ListTile(
                        leading: CircularProgressIndicator(),
                        title: Text('Loading...'),
                      ),
                    ],
                    error: (error, _) => [
                      ListTile(
                        leading: const Icon(Icons.error),
                        title: Text('Error: $error'),
                      ),
                    ],
                  );
                },
          ),
        ),
      ],
    );
  }
}
