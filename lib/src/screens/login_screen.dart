import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/tools/error_dialog.dart';
import 'package:app_herbal_flutter/src/tools/custom_error.dart';
import 'package:app_herbal_flutter/src/screens/splash_page.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart'; // ✅ Import CustomButton

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  SigninPageState createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;
void _showForgotPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: CustomTheme.containerColor, // Dark theme background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
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

  void _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    form.save();

    const apiKey = 'AIzaSyBRXZR6Abud4tBjdGYEF8QeGSOECQ3Qhkg';
    final authService = FirebaseAuthService(apiKey: apiKey);

    try {
      // Make the Firebase authentication request
      final response = await authService.signIn(_email!, _password!);

      // Save the token
      final token = response['idToken'];
      await AuthTokenStorage().saveToken(token);

      // Navigate to SplashPage to handle redirection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashPage()),
      );
    } catch (e) {
      // Show error dialog on failure
      errorDialog(context, CustomError(message: e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor, // Dark background
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min, // Ensures the column only takes the space it needs
                    children: [
                      const Text(
                        'Herbal App', // Change to your desired text
                          style: TextStyle(
                          fontSize: 40,
                          color: CustomTheme.lettersColor,
                          fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 20), // Space between text and logo
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: ClipOval(
                          child: FittedBox(
                            fit: BoxFit.contain, // Ensures the full image is inside the circle
                            child: Image.asset('lib/src/assets/images/logo_crux.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 130.0),

                  // Custom Input for Email
                  CustomInput(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Correo',
                    hintText: 'Ingrese su email',
                    icon: Icons.email,
                    borderColor: Colors.white,
                    iconColor: CustomTheme.lettersColor,
                    fillColor: CustomTheme.containerColor,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Correo requerido';
                      }
                      if (!isEmail(value.trim())) {
                        return 'Ingrese correo valido';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value,
                  ),

                  const SizedBox(height: 100.0),

                  // Custom Input for Password
                  CustomInput(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    labelText: 'Contraseña',
                    hintText: 'Ingrese su contraseña',
                    icon: Icons.lock,
                    borderColor: Colors.white,
                    iconColor: CustomTheme.lettersColor,
                    fillColor: CustomTheme.containerColor,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Contraseña requerida';
                      }
                      if (value.trim().length < 6) {
                        return 'Contraseña debe de ser de almenos 6 caracteres';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                  ),

                  const SizedBox(height: 60.0),

                  // ✅ CustomButton instead of ElevatedButton
                  Center(
                    child: Column(
                      children: [
                        CustomButton(
                          text: 'Ingresar',
                          onPressed: _submit, // Call the login function
                          height: 50.0,
                          width: MediaQuery.of(context).size.width * 0.4, // Half screen width
                        ),
                  const SizedBox(height: 30), // Space between button and text
                  TextButton(
                      onPressed: () => _showForgotPasswordDialog(context),
                      child: const Text(
                        
                        '¿Olvidó su contraseña?',
                        style: TextStyle(
                        color: CustomTheme.lettersColor, // Slightly dimmed for better UI
                        fontSize: 22,
                        decoration: TextDecoration.underline, // Underline for clarity
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
