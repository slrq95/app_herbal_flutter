import 'package:app_herbal_flutter/src/api/bottom_nav_index_provider.dart';
import 'package:app_herbal_flutter/src/api/dashboard_provider/dashboard_provider.dart';
import 'package:app_herbal_flutter/src/api/patient_services/patient_provider.dart';
import 'package:app_herbal_flutter/src/api/treatment_plan_services/treatment_plan_provider.dart';
import 'package:app_herbal_flutter/src/tools/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:app_herbal_flutter/src/api/payment_provider.dart';
import 'package:app_herbal_flutter/src/api/auth_services/dio_auth_provider.dart';
import 'package:app_herbal_flutter/src/api/appointement_services/appointment_provider.dart';
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





