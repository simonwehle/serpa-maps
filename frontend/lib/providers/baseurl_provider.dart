import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return dotenv.env['BASE_URL'] ?? "http://localhost:3465";
  }
}

final baseUrlProvider = NotifierProvider<BaseUrlNotifier, String>(
  BaseUrlNotifier.new,
);
