import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serpa_maps/providers/token/token_notifier.dart';

final refreshTokenProvider = NotifierProvider<TokenNotifier, String?>(
  () => TokenNotifier('refresh_token'),
);
