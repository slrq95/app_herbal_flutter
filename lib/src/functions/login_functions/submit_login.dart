import 'package:flutter/material.dart'; 
import 'package:app_herbal_flutter/src/api/auth_services/dio_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/tools/custom_error.dart';
import 'package:app_herbal_flutter/src/tools/error_dialog.dart';
import 'package:app_herbal_flutter/src/screens/splash_page.dart';

Future<void> submit(BuildContext context, TextEditingController emailController, TextEditingController passwordController) async {
  final form = Form.of(context); 
  if (!form.validate()) return;

  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final authProvider = Provider.of<DioAuthProvider>(context, listen: false);

  final success = await authProvider.signIn(email, password);

  if (!context.mounted) return; // check if widget is mounted in order to avoiding an error on async/await function

  if (success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SplashPage()),
    );
  } else {
    errorDialog(context, const CustomError(message: 'Credenciales incorrectas.'));
  }
}
