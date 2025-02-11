import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_herbal_flutter/src/api/provider/auth_services/dio_auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    // Delay to show splash effect in order to not use BuildContext inside an async function after an await or delayed execution.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return; // Ensure widget is still in the tree

    final authProvider = context.read<DioAuthProvider>();

    final route = authProvider.isAuthenticated ? '/home' : '/signin';
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
