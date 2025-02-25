import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
Widget buildPriceText(String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      '$label Q.$value',
      style: const TextStyle(
        color: Colors.green, // Highlights price
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget buildText(dynamic label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      '$label $value',
      style: const TextStyle(
        color: CustomTheme.lettersColor,
        fontSize: 16,
      ),
    ),
  );
}

// Extracted widget for consistency
Widget buildTitleText(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      '$label $value',
      style: const TextStyle(
        color: CustomTheme.lettersColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}