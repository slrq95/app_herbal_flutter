import 'package:app_herbal_flutter/src/api/bottom_nav_index_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/clinical_history/clinical_history_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/dashboard_provider/dashboard_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/treatment_plan_services/treatment_plan_provider.dart';
import 'package:app_herbal_flutter/src/tools/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:app_herbal_flutter/src/api/payment_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/auth_services/dio_auth_provider.dart';
import 'package:app_herbal_flutter/src/api/provider/appointement_services/appointment_provider.dart';
class Appstate extends StatelessWidget{
  const Appstate({super.key});
  @override
  Widget build(BuildContext context){
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Bottomnavindexprovider>(
          create:(_) =>Bottomnavindexprovider(),
        ),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => DioAuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => TreatmentPlanProvider()),
        ChangeNotifierProvider(create: (_) => SelectedPatientProvider()),
        ChangeNotifierProvider(create: (context) => PatientUpdateProvider()),
        ChangeNotifierProvider(create: (_)=>ClinicalHistoryProvider()),
        
        //ChangeNotifierProvider(create: (_) => VistaDatosProvider()),
      ],
      child: const MedicalApp(),
      );
  }
  
}
class MedicalApp extends StatelessWidget{
  const MedicalApp({super.key});
  
  @override
  Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      
      title: 'Herbal App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: '/',
      onGenerateRoute: MedicalRoute.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}





