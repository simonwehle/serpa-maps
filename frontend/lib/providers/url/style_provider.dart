import 'package:flutter_riverpod/flutter_riverpod.dart';

final styleUrlProvider = NotifierProvider<StyleUrlNotifier, String>(
  StyleUrlNotifier.new,
);

class StyleUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return 'https://tiles.openfreemap.org/styles/liberty';
  }

  void updateStyleUrl(String newUrl) {
    state = newUrl;
  }
}
