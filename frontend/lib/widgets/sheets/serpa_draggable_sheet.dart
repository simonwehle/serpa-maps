import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';

class SerpaDraggableSheet extends StatelessWidget {
  final Widget child;
  final Widget? bottomActions;
  final double initialChildSize;

  const SerpaDraggableSheet({
    super.key,
    required this.child,
    this.bottomActions,
    this.initialChildSize = 0.575,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SerpaBottomSheet(
              child: ListView(
                controller: scrollController,
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
