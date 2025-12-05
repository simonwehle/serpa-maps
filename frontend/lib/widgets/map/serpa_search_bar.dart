import 'dart:io';

import 'package:flutter/material.dart';

class SerpaSearchBar extends StatefulWidget {
  const SerpaSearchBar({super.key});

  @override
  State<SerpaSearchBar> createState() => _SerpaSearchBarState();
}

class _SerpaSearchBarState extends State<SerpaSearchBar> {
  bool isDark = false;
  bool isAndroid = Platform.isAndroid;
  bool isIOS = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isAndroid || isIOS) const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0),
                ),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
                  return List<ListTile>.generate(5, (int index) {
                    final String item = 'item $index';
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                },
          ),
        ),
      ],
    );
  }
}
