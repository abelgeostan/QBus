import 'package:flutter/material.dart';
//import 'package:sus_sample/components/mybutton.dart';
import 'package:sus_sample/screen_driver.dart';
import 'package:sus_sample/screen_login.dart';

class UserDriver extends StatelessWidget {
  const UserDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                builder: (_)=> ScreenDriver()
            ),
            );
              }, child: const Text("Driver"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 31, 68, 32),
              ),
              ),
              SizedBox(height: 40,),
              ElevatedButton(onPressed: (){
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                builder: (_)=> ScreenLogin()
            ),
            );
                
              }, child: const Text("Passenger"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 31, 68, 32),
              ),
              
              ),
            ],
          ),
        ) 
        ),
        backgroundColor: Color.fromARGB(255, 200, 200, 200),
    );
  }
}