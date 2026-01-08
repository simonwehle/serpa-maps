import 'package:flutter/material.dart';

class SerpaSelector extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final double radius;
  final double borderWidth;
  final double outerPadding;
  final double innerPadding;
  final VoidCallback? onTap;
  final bool isCircle;

  const SerpaSelector({
    super.key,
    required this.child,
    required this.isActive,
    this.radius = 20,
    required this.borderWidth,
    this.outerPadding = 4,
    required this.innerPadding,
    this.onTap,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(outerPadding),
        child: Container(
          decoration: BoxDecoration(
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(radius),
            border: Border.all(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: borderWidth,
            ),
          ),
          child: Padding(padding: EdgeInsets.all(innerPadding), child: child),
        ),
      ),
    );
  }
}
