import 'package:flutter/material.dart';

class SerpaDraggableSheet extends StatelessWidget {
  final Widget child;
  final Widget? bottomActions;

  const SerpaDraggableSheet({
    super.key,
    required this.child,
    this.bottomActions,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: ListView(
                controller: scrollController,
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
            child: Column(
              children: [
                Container(
                  //height: 1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Divider(
                    color: Theme.of(context).dividerColor,
                    indent: 16,
                    endIndent: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  color: Theme.of(context).colorScheme.surface,
                  child: bottomActions,
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
