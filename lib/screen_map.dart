// BusList.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sus_sample/driver_map.dart';
import 'package:sus_sample/main.dart';
import 'package:sus_sample/user_screenmap.dart';
// Adjust the import statement

class BusList extends StatefulWidget {
  const BusList({Key? key}) : super(key: key);

  @override
  _BusListState createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 194, 205, 210),
        title: Text("Bus list",style: TextStyle(color: Colors.black),),
        
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var busId = snapshot.data!.docs[index].id; // Get busId here

              return ListTile(
                title: Text(snapshot.data!.docs[index]['name'].toString()),
                subtitle: Row(
                  children: [
                    Text(snapshot.data!.docs[index]['latitude'].toString()),
                    SizedBox(width: 20),
                    Text(snapshot.data!.docs[index]['longitude'].toString()),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MyMap(snapshot.data!.docs[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
