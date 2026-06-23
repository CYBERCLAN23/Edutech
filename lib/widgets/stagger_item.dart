import 'package:flutter/material.dart';

class StaggerItem extends StatelessWidget {
  final int index;
  final Widget child;

  const StaggerItem({
    super.key,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Interval(
        (index * 0.06).clamp(0.0, 0.5),
        1.0,
        curve: Curves.easeOut,
      ),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
