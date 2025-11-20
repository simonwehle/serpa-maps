import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final imageProvider = FutureProvider.family<Uint8List, String>((
  ref,
  url,
) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception("Failed to load image");
  }
  return response.bodyBytes;
});
