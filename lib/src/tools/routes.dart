import 'package:app_herbal_flutter/src/screens/options_screen/dashboard_screen.dart';
import 'package:app_herbal_flutter/src/screens/login_screen.dart';

import 'package:app_herbal_flutter/src/screens/options_screen/options_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/appointment_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/clinical_history/clinical_history.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/clinical_history/odontrogram.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/payment_history_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/treatment_plan/treatement_plan_screen.dart';
import 'package:app_herbal_flutter/src/screens/patient_options/treatment_plan/treatment_plan_view.dart';
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
    return MaterialPageRoute(builder: (_) =>  const ClinicalHistoryPage());

case '/PaymentHistoryPage':
  final String? patientId = settings.arguments as String?; // Safe cast
  if (patientId == null) {
    return _errorRoute(); // Redirect to error page if patientId is null
  }
  return MaterialPageRoute(
    builder: (_) => PaymentHistory(patientId: patientId),
  );
  case'/TreatmentPlanPage':
    return MaterialPageRoute(builder: (_) =>  const TreatmentPlanScreen());

  case'/OdontogramPage':
    return MaterialPageRoute(builder: (_) =>  const OdotogramScreen());

case '/TreatmentPlanView':
  final dynamic patientId = settings.arguments as dynamic; // Retrieve patientId from arguments
  if (patientId == null) {
    return _errorRoute(); // Redirect to error page if patientId is null
  }
  return MaterialPageRoute(
    builder: (_) => TreatmentPlanView(patientId: patientId),
  );
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
