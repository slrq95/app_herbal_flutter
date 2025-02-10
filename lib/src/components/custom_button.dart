import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double? height;
  final TextStyle? style;
  final double? width;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.height,
    this.style,
    this.width,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height ?? 60.0,
        width: width ?? 200.0,
        alignment: Alignment.center, // Ensures text is centered inside
        decoration: BoxDecoration(
          color: color ?? CustomTheme.buttonColor,
          borderRadius: BorderRadius.circular(5.0),
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
