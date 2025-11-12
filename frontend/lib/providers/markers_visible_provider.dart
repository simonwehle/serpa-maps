import 'package:flutter_riverpod/flutter_riverpod.dart';

final markersVisibleProvider = NotifierProvider<MarkersVisibleNotifier, bool>(
  MarkersVisibleNotifier.new,
);

class MarkersVisibleNotifier extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void setMarkersVisible(bool newState) {
    state = newState;
  }
}
