import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme{
  static TextStyle title=GoogleFonts.hedvigLettersSans(
    color: const Color(0xFFFFFFFF),
    fontSize: 32.0,
    fontWeight: FontWeight.bold);

  static TextStyle label= GoogleFonts.raleway(
    color: const Color.fromARGB(255, 197, 197, 197),
    fontSize: 18,

  );

  static const Color primaryColor=Color(0xFF125542);
  static const Color secondaryColor= Color(0xFFCC2D37);
  static const Color onprimaryColor=Color(0XFF28BB91);
  static const Color tertiaryColor=Color(0xFFBB8028);
  static const Color buttonColor=Color(0xFF757575);
  static const Color fillColor=Color(0xFF121212);
  static const Color containerColor=Color(0xFF1E1E1E);
  static const Color lettersColor= Color.fromARGB(255, 197, 197, 197);
  static const List<Color> gradientes=[Color(0xFF2196F3), Color.fromARGB(255, 124, 71, 188)];
}