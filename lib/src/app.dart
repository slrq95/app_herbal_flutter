import 'package:app_herbal_flutter/src/api/bottom_nav_index_provider.dart';
import 'package:app_herbal_flutter/src/tools/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:app_herbal_flutter/src/api/payment_provider.dart';

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
      title: 'Dentistas App',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      initialRoute: '/',
      onGenerateRoute: MedicalRoute.onGenerateRoute,
       debugShowCheckedModeBanner: false,
    );
  }
}





