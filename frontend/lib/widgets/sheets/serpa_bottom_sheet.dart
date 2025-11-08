import 'package:flutter/material.dart';

class SerpaBottomSheet extends StatelessWidget {
  final Widget child;
  final Widget? bottomActions;

  const SerpaBottomSheet({super.key, required this.child, this.bottomActions});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.2,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 8),
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
          },
        ),
        if (bottomActions != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: bottomActions,
            ),
          ),
      ],
    );
  }
}

void showSerpaBottomSheet({
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
