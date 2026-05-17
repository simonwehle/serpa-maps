import 'package:flutter_riverpod/flutter_riverpod.dart';

final geoencodingUrlProvider = NotifierProvider<GeoencodingUrlNotifier, String>(
  GeoencodingUrlNotifier.new,
);

class GeoencodingUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return 'https://photon.komoot.io/';
  }

  void updateBaseUrl(String newUrl) {
    state = newUrl;
  }
}
