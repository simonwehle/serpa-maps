import 'package:flutter_riverpod/flutter_riverpod.dart';

final pmTilesActiveProvider = NotifierProvider<PmtilesActiveNotifier, bool>(
  PmtilesActiveNotifier.new,
);

class PmtilesActiveNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setPmtiles(bool newState) {
    state = newState;
  }
}
