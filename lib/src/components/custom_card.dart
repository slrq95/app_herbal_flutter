import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
class CustomCard extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color color;

  const CustomCard({
    super.key,
    required this.child,
    this.height,
    this.padding,
    this.borderRadius,
    this.color = CustomTheme.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 180, // Set a consistent height for better alignment
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
