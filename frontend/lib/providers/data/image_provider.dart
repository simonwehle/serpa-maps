import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/api/dio_provider.dart';

final imageProvider = FutureProvider.family<Uint8List, String>((
  ref,
  url,
) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<List<int>>(
    url,
    options: Options(responseType: ResponseType.bytes),
  );

  final body = response.data;
  if (response.statusCode != 200 || body == null) {
    throw Exception("Failed to load image");
  }

  return Uint8List.fromList(body);
});
