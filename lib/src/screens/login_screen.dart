import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:app_herbal_flutter/src/tools/error_dialog.dart';
import 'package:app_herbal_flutter/src/tools/custom_error.dart';
import 'package:app_herbal_flutter/src/screens/splash_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  SigninPageState createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  String? _email, _password;

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
        backgroundColor: const Color(0xFF121212), // ✅ Set background color here
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidateMode,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Image.asset(
                    'lib/src/assets/images/algo.jpg',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E), // ✅ Input field color
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: Colors.white70),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email required';
                      }
                      if (!isEmail(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E), // ✅ Input field color
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                      labelStyle: const TextStyle(color: Colors.white70),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password required';
                      }
                      if (value.trim().length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Sign In'),
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
