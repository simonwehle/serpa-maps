import 'package:flutter_riverpod/flutter_riverpod.dart';

final overlayUrlProvider = NotifierProvider<OverlayUrlNotifier, String>(
  OverlayUrlNotifier.new,
);

class OverlayUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void updateOverlayUrl(String newUrl) {
    state = newUrl;
  }
}
