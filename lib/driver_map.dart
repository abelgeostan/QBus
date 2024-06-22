import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:sus_sample/ticket.dart';

class MyMap extends StatefulWidget {
  final String user_id;
  MyMap(this.user_id);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  loc.LocationData? _userLocation;
  @override

  void initState(){
    addCustomIcon();
    super.initState();
  }
  void addCustomIcon(){
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), "assets/bus_icon_low.png")
      .then((icon) => markerIcon =icon);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(255, 194, 205, 210),
        title: Text("Quick Bus",style: TextStyle(color: Colors.black),),),
        body: Column(
          children: [
            Expanded(
              flex: 7,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('location').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (_added) {
                mymap(snapshot);
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(
                      position: LatLng(
                        snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.user_id)['latitude'],
                        snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.user_id)['longitude'],
                      ),
                      markerId: MarkerId('id'),
                      icon: markerIcon,)
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.user_id)['latitude'],
                      snapshot.data!.docs.singleWhere(
                          (element) => element.id == widget.user_id)['longitude'],
                    ),
                    zoom: 14.47),
                onMapCreated: (GoogleMapController controller) async {
                  setState(() {
                    _controller = controller;
                    _added = true;
                  });
                },
              );
                  },
                ),
            ),
            Expanded(
            flex: 3,
            child: Container(
              // Your container content goes here
              color: Color.fromARGB(255, 200, 200, 200), // Example color, you can customize this
              child: Center(
                child: Text("ETA details and bus name "),
                
              ),
            ),
          ),
          TextButton(child: Text("Confirm"),
                onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    TicketScreen()));
                })
          ],
        ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.47)));
  }
  
}