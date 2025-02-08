import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/app.dart';


Future<void> main() async{
 // Disables the debug banner  
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(const Appstate());

}