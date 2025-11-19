import 'package:flutter/material.dart';

class SerpaBottomSheet extends StatelessWidget {
  final Widget child;

  const SerpaBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        //padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

void showSerpaBottomSheet({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = false,
  Color backgroundColor = Colors.transparent,
  Color barrierColor = Colors.transparent,
  bool isDismissible = true,
  bool enableDrag = false,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    builder: (_) => child,
  );
}
