import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sus_sample/components/mytextfield.dart';
import 'package:sus_sample/screen_login.dart';
import 'package:sus_sample/screen_map.dart';
import 'package:sus_sample/user_driver_scrn.dart';


class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final fromController = TextEditingController();
  final destinationController = TextEditingController();

  late LatLng destination;
  late LatLng source;

  static const LatLng _rajagiri=LatLng(9.993248920649345, 76.35800500002435);
  void handleClick(String value,BuildContext context) {
    switch (value) {
      case 'Logout':
      signout(context);
        
        break;
      case 'Settings':
        break;
    }
}

  signout(BuildContext context)async{
    final _sharedPrefs=await SharedPreferences.getInstance();
    await _sharedPrefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
          builder: (_)=> UserDriver()
          ),
          (route) => false);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 194, 205, 210),
        title: Text("Quick Bus",style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value){
              handleClick(value,context);
              },
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        color:  Color.fromARGB(255, 225, 228, 230),
        child: Center(
          
          child: SafeArea(
            //child: Text("this is where something is supposed to be")
            
            child: Column(
              children:[
              
              Expanded(
                child: Column(children: [
                  SizedBox(height: 40,),
                  MyTextField(controller: fromController, hintText: "Enter from location", obscureText: false),
                  SizedBox(height: 40,),
                  MyTextField(controller: destinationController, hintText: "Enter destination location", obscureText: false),
                  SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    // fromLocation = LatLng(37.7749, -122.4194);
                    // destinationLocation = LatLng(37.7749, -122.5194);

                    // _goToLocation(fromLocation);
                    // setState(() {});
                    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                    builder: (_)=> BusList()
                    ),
                    );
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 45, 57, 45),
              ),
                ),
                ]),
              ),
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                ),
                child: GoogleMap(
                initialCameraPosition: CameraPosition(
                target: _rajagiri,
                zoom: 13
                ),
                ),
              ),
              )
              ]
            ),
        ),
          ),
      )
    );
  }
}