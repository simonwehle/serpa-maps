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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SheetHeader(title: title),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: child,
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}

void showSerpaStaticSheet({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
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
    builder: (ctx) => GestureDetector(
      onTap: isDismissible ? () => Navigator.of(ctx).pop() : null,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Align(alignment: Alignment.bottomCenter, child: child),
      ),
    ),
  );
}
