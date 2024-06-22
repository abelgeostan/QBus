

//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sus_sample/main.dart';
import 'package:sus_sample/screen_home.dart';
//import 'package:sus_sample/screen_home.dart';
import 'package:sus_sample/screen_login.dart';
import 'package:sus_sample/user_driver_scrn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    checkUserLoggedIn();
  }
  
  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 205, 210),
      body: Container(
        width: double.infinity,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(image: AssetImage("assets/qbus_logo.png")),
            //SizedBox(height: 20,),
            Text(
              "Quick Bus",
              style: TextStyle(
                color: Color.fromARGB(255, 56, 56, 56),
                fontSize: 20,
              ),)

          ],
        ),
      ),
    );
  }

  Future<void>checkUserLoggedIn()async{
    final _sharedpref =await SharedPreferences.getInstance();
    final _userLoggedIn=_sharedpref.getBool(SAVE_KEY_NAME);
    
    //return _userLoggedIn ?? false;//idk
    if(_userLoggedIn==null || _userLoggedIn==false){
      //initState();
      Future.delayed(Duration(seconds: 3),(){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_)=> UserDriver()
          ),
          );
    });
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context)=>ScreenHome()
          )
          );
    }
  }
}