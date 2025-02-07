import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String labelText;
  final String hintText;
  final IconData icon;
  final Color borderColor;
  final Color iconColor;
  final Color fillColor;
  final double width;  
  final double height; 
  final double fontSize; 
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  const CustomInput({
    super.key,
    this.controller,
    required this.keyboardType,
    this.obscureText = false,
    required this.labelText,
    required this.hintText,
    required this.icon,
    required this.borderColor,
    required this.iconColor,
    required this.fillColor,
    this.width = double.infinity, 
    this.height = 90.0, 
    this.fontSize = 24.0, 
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, 
      height: height, 
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: fillColor,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon, color: iconColor),
          labelStyle: TextStyle(color: CustomTheme.lettersColor, fontSize: fontSize), // Font size applied ✅
        ),
        style: TextStyle(color: CustomTheme.lettersColor, fontSize: fontSize), // Font size applied ✅
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
