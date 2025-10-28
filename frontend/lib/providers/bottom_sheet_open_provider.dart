import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomSheetOpenProvider = NotifierProvider<BottomSheetOpenNotifier, bool>(
  BottomSheetOpenNotifier.new,
);

class BottomSheetOpenNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void openSheet() {
    state = true;
  }

  void closeSheet() {
    state = false;
  }
}
