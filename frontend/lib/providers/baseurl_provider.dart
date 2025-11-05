import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final baseUrlProvider = Provider<String>((ref) {
  return dotenv.env['BASE_URL'] ?? "http://localhost:53164";
});
