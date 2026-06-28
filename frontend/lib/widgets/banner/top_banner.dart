import 'package:flutter/material.dart';

void showTopBanner(BuildContext context, String message, {bool isError = false}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: ScaffoldMessenger(
          key: messengerKey,
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox.shrink(),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  // wait one frame so the ScaffoldMessenger is actually mounted before calling showSnackBar
  WidgetsBinding.instance.addPostFrameCallback((_) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : null,
      ),
    );
  });

  Future.delayed(const Duration(seconds: 4), () => entry.remove());
}