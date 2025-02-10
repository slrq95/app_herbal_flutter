import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/theme/default.dart';
import 'package:app_herbal_flutter/src/components/custom_input.dart';
import 'package:app_herbal_flutter/src/components/custom_button.dart';
import 'package:app_herbal_flutter/src/api/auth_services/dio_auth_provider.dart';
import 'package:app_herbal_flutter/src/functions/login_functions/forgot_password.dart';
import 'package:app_herbal_flutter/src/functions/login_functions/submit_login.dart'; 

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  SigninPageState createState() => SigninPageState();
}

class SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: SafeArea( // ✅ Wrap Scaffold with SafeArea
      child: Scaffold(
        backgroundColor: CustomTheme.fillColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Herbal App',
                        style: TextStyle(
                          fontSize: 40,
                          color: CustomTheme.lettersColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 260,
                        height: 260,
                        child: ClipOval(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset('lib/src/assets/images/logo_crux.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 130.0),

                  // Email Input
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
                        return 'Ingrese un correo válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 100.0),

                  // Password Input
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
                        return 'Contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 60.0),

                  // Login Button with Consumer
                  Center(
                    child: Column(
                      children: [
                        Consumer<DioAuthProvider>(
                          builder: (context, authProvider, _) {
                            return authProvider.isLoading
                                ? const CircularProgressIndicator()
                                : CustomButton(
                                    text: 'Ingresar',
                                    onPressed: () => submit(context, _emailController, _passwordController),
                                    height: 50.0,
                                    width: MediaQuery.of(context).size.width * 0.4,
                                  );
                          },
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: () => showForgotPasswordDialog(context),
                          child: const Text(
                            '¿Olvidó su contraseña?',
                            style: TextStyle(
                              color: CustomTheme.lettersColor,
                              fontSize: 22,
                              decoration: TextDecoration.underline,
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
    ),
  );
}
}