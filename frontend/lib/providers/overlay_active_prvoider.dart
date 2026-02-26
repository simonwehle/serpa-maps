import 'package:flutter_riverpod/flutter_riverpod.dart';

final overlayActiveProvider = NotifierProvider<OverlayActiveNotifier, bool>(
  OverlayActiveNotifier.new,
);

class OverlayActiveNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setOverlayActive(bool newState) {
    state = newState;
  }
}
