import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sus_sample/main.dart';
import 'package:sus_sample/screen_driver.dart';
import 'package:sus_sample/screen_home.dart';

import 'components/mybutton.dart';
import 'components/mytextfield.dart';
import 'components/squaretile.dart';

class ScreenLogin extends StatelessWidget {
  ScreenLogin({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  Future<void> signUserIn(BuildContext ctx) async {
    final _username = usernameController.text;
    final _password = passwordController.text;

    // if(_username=='driver'&&_password=='driver'){
    //   Navigator.of(ctx).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (_)=> ScreenDriver()
    //       ),
    //       );
     
    // }
    // else 
    if(_username==_password&&_username!=""){
       //go to home screen

      final _sharedPrefs=await SharedPreferences.getInstance();
      await _sharedPrefs.setBool(SAVE_KEY_NAME, true);

      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(
          builder: (_)=> ScreenHome()
          ),
          );

    }
    else{

      final _errormsg="Username password doesn't match";

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(10),
          content: Text(_errormsg),
          duration: Duration(seconds: 5),
          ),
          
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 205, 210),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              
              children:  [
                
                //SizedBox(height: 40,),
                const Image(image: AssetImage("assets/qbus_logo.png")),
                //Icon(Icons.bus_alert_sharp,size: 140,),
                //SizedBox(height: 5,),
                Text("Welcome to 'Quick Bus'",
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                ),
                ),
          
                SizedBox(height: 20,),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                 const SizedBox(height: 10),
          
                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
          
                const SizedBox(height: 10),
          
                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 25),
          
                // sign in button
                MyButton(
                  onTap: (){signUserIn(context);},
                ),
          
                const SizedBox(height: 50),
                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 50),
          
                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    SquareTile(imagePath: 'assets/google.png'),
          
                    SizedBox(width: 25),
          
                    // apple button
                    SquareTile(imagePath: 'assets/apple.png')
                  ],
                ),
          
                const SizedBox(height: 4),
          
          
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Register now',
                      style: TextStyle(
                        color: Color.fromARGB(255, 114, 192, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
          
          
          
              ],
            ),
          ),
        ),
      ),      
    );
  }
}