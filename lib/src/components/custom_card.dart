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
    this.color =CustomTheme.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity, // Takes full width
      height: height ?? screenHeight * 0.10, // Default height is 10% of screen height
      padding: padding ?? const EdgeInsets.all(16.0), // Default padding
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: CustomTheme.containerColor.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: child, // Custom content
    );
  }
}