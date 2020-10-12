import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ListViewPage extends StatelessWidget{
  CollectionReference collectionReference = Firestore.instance.collection(
      "tribal_talents");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tribal talent'), backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white70,
      body: StreamBuilder(
          stream: Firestore.instance.collection("tribal_talents").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');


            return ListView.builder(
            shrinkWrap: true,
            itemExtent: 80.0,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
            _listc(context, snapshot.data.documents[index]),
            );
          }),

    );
  }

  Widget _listc(BuildContext context, DocumentSnapshot doc) {
    return Card(
      child: Container(
        child: Column(
        children: <Widget>[
          Text("Name : "+doc.data["name"]),
        Text("Tribe : " +doc.data["tribe"]),
          Text("Area : "+doc.data["area"]),
          Text("Talent : "+doc.data["talent"]),
        ],
        ),

      ),
    );
  }


}