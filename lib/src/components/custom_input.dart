import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
class CustomInput extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? padding;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final TextStyle? style;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool? rounded;
  final bool? isDense;
  final bool? autofocus;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final String? icon;
  final double? width;
  final double? height;
  final int? maxLines;
  final Color? fillColor;
  final Color? borderColor;
  final Color? iconColor;
  final TextAlign? textAlign;

  const CustomInput({
    super.key,
    required this.controller,
    this.keyboardType,
    this.onChanged,
    this.style,
    this.focusNode,
    this.padding,
    this.onTap,
    this.obscureText,
    this.rounded,
    this.isDense,
    this.autofocus,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.icon,
    this.width,
    this.height,
    this.maxLines,
    this.fillColor,
    this.borderColor,
    this.iconColor,
    this.textAlign,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        onTap: onTap,
        autofocus: autofocus ?? false,
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines ?? 1,
        style: style ?? const TextStyle(
          color: CustomTheme.lettersColor,
          fontSize: 16,
        ),
        onChanged: onChanged,
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: labelStyle,
          hintText: hintText,
          fillColor: CustomTheme.containerColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded == true ? 30.0 : 5.0),
            borderSide: BorderSide(color: borderColor ?? Colors.white),
          ),
 
        ),
        obscureText: obscureText ?? false,
      ),
    );
  }
}
