import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/dio_provider.dart';
import 'package:serpa_maps/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});
