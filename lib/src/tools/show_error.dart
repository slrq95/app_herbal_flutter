import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:flutter/material.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: CustomTheme.fillColor, // Dark background
        title: const Text(
          "Atención",
          style: TextStyle(color: CustomTheme.lettersColor, fontSize: 26), // White text
        ),
        content: Text(
          message,
          style: const TextStyle(color: CustomTheme.lettersColor, fontSize: 22), // White text
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(color: CustomTheme.lettersColor,fontSize: 22), // White text
            ),
          ),
        ],
      );
    },
  );
}
