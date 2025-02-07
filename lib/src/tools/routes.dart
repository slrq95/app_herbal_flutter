import 'package:app_herbal_flutter/src/screens/dashboard_screen.dart';
import 'package:app_herbal_flutter/src/screens/login_screen.dart';

import 'package:app_herbal_flutter/src/screens/options_screen.dart';
import 'package:app_herbal_flutter/src/screens/splash_page.dart';
import 'package:app_herbal_flutter/src/screens/patient_screen.dart';
import 'package:flutter/material.dart';


class MedicalRoute{
  static Route onGenerateRoute(RouteSettings settings){
switch(settings.name){
  case'/':
    return MaterialPageRoute(builder: (_) => const SplashPage());
  case'/home':
    return MaterialPageRoute(builder: (_) => const PaginaPrincipal());
  case'/signin':
  return MaterialPageRoute(builder: (_) => const SigninPage());  
  
  case'/PatientPage':
    return MaterialPageRoute(builder: (_) => const PantientPage());
  
  case'/DasboardPage':
    return MaterialPageRoute(builder: (_) => const DashboardScreen());
    


  default:
    _errorRoute();
    }
    return _errorRoute();
  }
  static Route _errorRoute(){
    return MaterialPageRoute(builder: (_)=> Scaffold(
      appBar: AppBar( 
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('ERROR'),
      ),
    ));
  }
} 
