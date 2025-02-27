import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double? height;
  final TextStyle? style;
  final double? width;
    final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.height,
    this.style,
    this.width,
    this.onPressed,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(borderRadius ?? 80.0),
      child: Container(
        height: height ?? 60.0,
        width: width ?? 200.0,
        alignment: Alignment.center, // Ensures text is centered inside
        decoration: BoxDecoration(
          
          color: color ?? CustomTheme.buttonColor,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade300, // Default is no border
            width: borderWidth ?? 3.0, // Default is no border width
          ),
          
        ),
        child: Center(
          child: Text(
            text,
            style: style ?? const TextStyle(
              color: CustomTheme.lettersColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center, // Centers text horizontally
          ),
        ),
      ),
    );
  }
}
