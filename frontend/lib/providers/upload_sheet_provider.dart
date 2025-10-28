import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadSheetProvider = NotifierProvider<UploadSheetNotifier, bool>(
  UploadSheetNotifier.new,
);

class UploadSheetNotifier extends Notifier<bool> {
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
