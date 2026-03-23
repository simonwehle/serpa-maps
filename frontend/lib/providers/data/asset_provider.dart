import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assetProvider = FutureProvider.family<Uint8List, String>((
  ref,
  url,
) async {
  final dio = Dio();
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
