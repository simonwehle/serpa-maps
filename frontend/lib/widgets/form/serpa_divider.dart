import 'package:flutter/material.dart';

class SerpaDivider extends StatelessWidget {
  final double indent;
  final double endIndent;

  const SerpaDivider({super.key, this.indent = 16.0, this.endIndent = 16.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 1,
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Divider(
        color: Theme.of(context).dividerColor,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }
}
