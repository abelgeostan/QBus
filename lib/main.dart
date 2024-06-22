import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:sus_sample/screen_home.dart';
import 'package:sus_sample/splash_screen.dart';

const SAVE_KEY_NAME="UserLoggedIn";


void main(List<String> args) async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}