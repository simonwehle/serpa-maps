import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseUrlProvider = NotifierProvider<BaseUrlNotifier, String>(
  BaseUrlNotifier.new,
);

class BaseUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void updateBaseUrl(String newUrl) {
    state = newUrl;
  }
}
