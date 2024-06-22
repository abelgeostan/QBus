import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

//not used ____________________________

class MapScreen extends StatefulWidget {
  final String user_id;

  MapScreen(this.user_id);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  LatLng userLocation = LatLng(0, 0); // Default user location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_added) {
            myMap(snapshot);
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Extract driver's location
          // LatLng driverLocation = LatLng(
          //   snapshot.data!.docs.singleWhere(
          //     (element) => element.id == widget.user_id)['latitude'],
          //   snapshot.data!.docs.singleWhere(
          //     (element) => element.id == widget.user_id)['longitude'],
          // );

          return GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                position: LatLng(
                  snapshot.data!.docs.singleWhere(
              (element) => element.id == widget.user_id)['latitude'],
            snapshot.data!.docs.singleWhere(
              (element) => element.id == widget.user_id)['longitude'],),
                markerId: MarkerId('driver'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta,
                ),
              ),
              Marker(
                position: userLocation,
                markerId: MarkerId('user'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,     
                ),
              ),
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(9.99375623946968, 76.35816599741905),
              zoom: 14.47,
            ),
            onMapCreated: (GoogleMapController controller) async {
              setState(() {
                _controller = controller;
                _added = true;
              });
            },
          );
        },
      ),
    );
  }

  Future<void> myMap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    // Extract user's location
    // For simplicity, you can use the device's current location
    loc.LocationData currentLocation = await location.getLocation();
    userLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);

    await _controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(
            snapshot.data!.docs.singleWhere(
              (element) => element.id == widget.user_id)['latitude'],
            snapshot.data!.docs.singleWhere(
              (element) => element.id == widget.user_id)['longitude'],
          ),
          southwest: userLocation,
        ),
        150.0, // Padding value to ensure both markers are visible
      ),
    );
  }
}
