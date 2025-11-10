import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pmtilesProvider = Provider<String>((ref) {
  return dotenv.env['PMTILES'] ?? '';
});
