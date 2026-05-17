import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/l10n/app_localizations.dart';

import 'package:serpa_maps/providers/data/place_provider.dart';
import 'package:serpa_maps/providers/data/category_provider.dart';
import 'package:serpa_maps/providers/api/photon_provider.dart';
import 'package:serpa_maps/models/place.dart';
import 'package:serpa_maps/widgets/category/category_icon.dart';

class SerpaSearchBar extends ConsumerStatefulWidget {
  final Function(Place)? onPlaceSelected;
  final Function(double, double)? onPositionSelected;
  final Function()? openUserSheet;
  final Function()? openCategorySheet;

  const SerpaSearchBar({
    super.key,
    this.onPlaceSelected,
    this.onPositionSelected,
    this.openUserSheet,
    this.openCategorySheet,
  });

  @override
  ConsumerState<SerpaSearchBar> createState() => _SerpaSearchBarState();
}

class _SerpaSearchBarState extends ConsumerState<SerpaSearchBar> {
  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                focusNode: _searchFocusNode,
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
                trailing: <Widget>[
                  GestureDetector(
                    onTap: () {
                      widget.openUserSheet?.call();
                    },
                    child: const Icon(Icons.person),
                  ),
                ],
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  return [
                    Consumer(
                      builder: (context, ref, child) {
                        final query = controller.text;
                        final placesAsync = ref.watch(placeProvider);
                        final categoriesAsync = ref.watch(categoryProvider);
                        final photonPlacesAsync = ref.watch(
                          photonSearchProvider(query),
                        );

                        if (placesAsync.hasError) {
                          return ListTile(
                            leading: const Icon(Icons.error),
                            title: Text('Error: ${placesAsync.error}'),
                          );
                        }

                        if (placesAsync.isLoading) {
                          return const SizedBox.shrink();
                        }

                        final localPlaces = placesAsync.value ?? [];
                        final onlinePlaces = photonPlacesAsync.value ?? [];

                        final filteredLocalPlaces = query.isEmpty
                            ? localPlaces
                            : localPlaces
                                  .where(
                                    (p) => p.name.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ),
                                  )
                                  .toList();

                        final List<Widget> suggestions = [];

                        // Build suggestions for local places
                        for (var place in filteredLocalPlaces) {
                          final category = categoriesAsync.value?.firstWhere(
                            (cat) => cat.id == place.categoryId,
                            orElse: () => null as dynamic,
                          );
                          suggestions.add(
                            ListTile(
                              leading: category != null
                                  ? CategoryIcon(category: category)
                                  : const Icon(Icons.history),
                              title: Text(place.name),
                              onTap: () {
                                _searchFocusNode.unfocus();
                                controller.closeView(place.name);
                                widget.onPlaceSelected?.call(place);
                              },
                            ),
                          );
                        }

                        if (suggestions.isNotEmpty &&
                            onlinePlaces.isNotEmpty &&
                            query.isNotEmpty) {
                          suggestions.add(const Divider(height: 1));
                        }

                        for (var place in onlinePlaces) {
                          suggestions.add(
                            ListTile(
                              leading: const Icon(Icons.travel_explore),
                              title: Text(place.name),
                              subtitle: Text(place.description ?? ''),
                              onTap: () {
                                _searchFocusNode.unfocus();
                                controller.closeView(place.name);
                                widget.onPositionSelected?.call(
                                  place.latitude,
                                  place.longitude,
                                );
                              },
                            ),
                          );
                        }

                        if (query.isEmpty && filteredLocalPlaces.isEmpty) {
                          return ListTile(title: Text(l10n.searchPlaces));
                        }

                        if (query.isNotEmpty &&
                            suggestions.isEmpty &&
                            !photonPlacesAsync.isLoading) {
                          return const ListTile(
                            title: Text('No results found'),
                          );
                        }

                        if (photonPlacesAsync.hasError && query.isNotEmpty) {
                          suggestions.add(
                            const ListTile(
                              leading: Icon(
                                Icons.error_outline,
                                color: Colors.grey,
                              ),
                              title: Text(
                                'Online search failed',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(children: suggestions),
                        );
                      },
                    ),
                  ];
                },
          ),
        ),
      ],
    );
  }
}
