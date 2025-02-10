import 'package:app_herbal_flutter/src/screens/options_screen/dashboard_screen.dart';
import 'package:app_herbal_flutter/src/screens/login_screen.dart';

import 'package:app_herbal_flutter/src/screens/options_screen/options_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/appointment_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/clinical_history.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/payment_history_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/treatement_plan_screen.dart';
import 'package:app_herbal_flutter/src/screens/splash_page.dart';
import 'package:app_herbal_flutter/src/screens/options_screen/patient_screen.dart';
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

  case'/AppointmentPage':
    return MaterialPageRoute(builder: (_) => const AppointmentPage());

  case'/ClinicalHistoryPage':
    return MaterialPageRoute(builder: (_) =>  ClinicalHistoryPage());

  case'/PaymentHistoryPage':
    return MaterialPageRoute(builder: (_) =>  const PaymentHistory());
  
  case'/TreatmentPlanPage':
    return MaterialPageRoute(builder: (_) =>  const TreatmentPlanScreen());

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
