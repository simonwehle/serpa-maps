import 'package:flutter_riverpod/flutter_riverpod.dart';

class TappedPlaceIdNotifier extends Notifier<int?> {
  @override
  int? build() {
    return null;
  }

  void setPlaceId(int? placeId) {
    state = placeId;
  }
}

final tappedPlaceIdProvider = NotifierProvider<TappedPlaceIdNotifier, int?>(
  TappedPlaceIdNotifier.new,
);
