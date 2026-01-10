import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final overlayUrlProvider = NotifierProvider<OverlayUrlNotifier, String>(
  OverlayUrlNotifier.new,
);

class OverlayUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return dotenv.env['OVERLAY_URL'] ?? '';
  }

  void updateOverlayUrl(String newUrl) {
    state = newUrl;
  }
}
