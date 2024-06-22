import 'dart:async';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

import 'driver_map.dart';

class ScreenDriver extends StatefulWidget {
  const ScreenDriver({super.key});

  @override
  State<ScreenDriver> createState() => _ScreenDriverState();
}

class _ScreenDriverState extends State<ScreenDriver> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  @override
  void initState() {
    super.initState();
    _requestPermission();
    // location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    // location.enableBackgroundMode(enable: true);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 219, 219),
      appBar: AppBar( backgroundColor: Color.fromARGB(255, 194, 205, 210),
        title: Text("Quick Bus",style: TextStyle(color: Colors.black),),),
      body: SafeArea(
        
        child: Center(child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  // TextButton(onPressed: (){
                  //   _getLocation();
                  // }, child: Text("add my location")),
                  TextButton(onPressed: (){
                    _getLocation();
                    _listenLocation();
                  }, child: Text("enable live location")),
                  TextButton(onPressed: (){
                    _stopListening();
                    
                  }, child: Text("stop live location")),
                  
                  Expanded(
                    flex:4,
                      child: StreamBuilder(
                    stream:
                        FirebaseFirestore.instance.collection('location').snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data!.docs[index]['name'].toString()),
                              subtitle: Row(
                                children: [
                                  Text(snapshot.data!.docs[index]['latitude']
                                      .toString()),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(snapshot.data!.docs[index]['longitude']
                                      .toString()),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.directions),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MyMap(snapshot.data!.docs[index].id
                                          )));
                                },
                              ),
                            );
                          });
                    },
                  )),
                ],
              ),
            ),
          ],
        )),
      ),
      
    );
  }
  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'KSRTC'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }
  

 

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'KSRTC'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
