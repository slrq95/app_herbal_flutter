import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
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
  Widget build(BuildContext context){

    return InkWell(
    
    onTap: onPressed,
    child: Container(
      
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: CustomTheme.buttonColor,
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: Center(
        child: Text(
          text,
          style: style ?? const TextStyle(
            color: CustomTheme.lettersColor,
            fontSize: 16.0,
            height: 5.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        
      ),
    ),


    );
  }

}