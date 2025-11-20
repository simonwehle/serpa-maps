import 'package:flutter/material.dart';
import 'package:serpa_maps/widgets/sheets/serpa_bottom_sheet.dart';
import 'package:serpa_maps/widgets/sheets/sheet_header.dart';

class SerpaStaticSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const SerpaStaticSheet({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SerpaBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SheetHeader(title: title),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

void showSerpaStaticSheet({
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
