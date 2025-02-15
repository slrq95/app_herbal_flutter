import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_herbal_flutter/src/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async{

WidgetsFlutterBinding.ensureInitialized();
await dotenv.load(fileName: '.env');
await Firebase.initializeApp();
runApp(const Appstate());

}