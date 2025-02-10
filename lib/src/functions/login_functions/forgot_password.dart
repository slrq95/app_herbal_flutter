  import 'package:flutter/material.dart';
  import 'package:app_herbal_flutter/src/theme/default.dart';
  void showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: CustomTheme.containerColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'Recuperar contraseña',
            style: TextStyle(color: CustomTheme.lettersColor, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Por favor, comuníquese con soporte técnico para recuperar su contraseña.',
            style: TextStyle(color: CustomTheme.lettersColor, fontSize: 28),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }