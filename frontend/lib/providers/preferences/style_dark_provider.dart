import 'package:flutter_riverpod/flutter_riverpod.dart';

final styleDarkUrlProvider = NotifierProvider<StyleDarkUrlNotifier, String>(
  StyleDarkUrlNotifier.new,
);

class StyleDarkUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return 'https://raw.githubusercontent.com/simonwehle/osm-liberty-dark/refs/heads/main/style.json';
  }

  void updateStyleDarkUrl(String newUrl) {
    state = newUrl;
  }
}
