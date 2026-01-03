import 'package:flutter_riverpod/flutter_riverpod.dart';

final styleDarkUrlProvider = NotifierProvider<StyleDarkUrlNotifier, String>(
  StyleDarkUrlNotifier.new,
);

class StyleDarkUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return 'https://tiles.openfreemap.org/styles/dark';
  }

  void updateStyleDarkUrl(String newUrl) {
    state = newUrl;
  }
}
