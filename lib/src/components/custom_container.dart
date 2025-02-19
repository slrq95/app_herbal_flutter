import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final Color color;
  final BorderRadius? borderRadius;

  const CustomContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.color =CustomTheme.containerColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive size - ensures the container has a nice proportion
    double containerWidth = width ?? screenWidth * 0.4;
    double containerHeight = height ?? screenHeight * 0.3;

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: CustomTheme.containerColor.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}