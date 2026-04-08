import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/form/serpa_divider.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';

class SerpaDraggableSheet extends StatefulWidget {
  final Widget child;
  final Widget? bottomActions;
  final double initialChildSize;

  const SerpaDraggableSheet({
    super.key,
    required this.child,
    this.bottomActions,
    this.initialChildSize = 0.6,
  });

  @override
  State<SerpaDraggableSheet> createState() => _SerpaDraggableSheetState();
}

class _SerpaDraggableSheetState extends State<SerpaDraggableSheet> {
  late DraggableScrollableController _controller;
  double _previousKeyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleKeyboardChange(double keyboardHeight) {
    if (!_controller.isAttached) return;

    if (keyboardHeight > 0 && _previousKeyboardHeight == 0) {
      _controller.animateTo(
        0.9,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (keyboardHeight == 0 && _previousKeyboardHeight > 0) {
      // Return to initial size
      _controller.animateTo(
        widget.initialChildSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    _previousKeyboardHeight = keyboardHeight;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleKeyboardChange(keyboardHeight);
    });

    return Stack(
      children: [
        DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: widget.initialChildSize,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return SerpaBottomSheet(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.only(bottom: keyboardHeight),
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  widget.child,
                ],
              ),
            );
          },
        ),
        if (widget.bottomActions != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SerpaDivider(),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  color: Theme.of(context).colorScheme.surface,
                  child: widget.bottomActions,
                ),
                Container(
                  height: 16,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

void showSerpaDraggableSheet({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  Color backgroundColor = Colors.transparent,
  Color barrierColor = Colors.transparent,
  bool isDismissible = true,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    isDismissible: isDismissible,
    builder: (_) => child,
  );
}
