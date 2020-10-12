import 'package:flutter/material.dart';
import 'package:tribal_repository/Aboutus.dart';
import 'package:tribal_repository/password.dart';
import 'package:tribal_repository/ListViewPage.dart';
class home extends StatefulWidget {
  @override
  _homeState createState() => new _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tribal talents'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white60,
      body:ListView(
        padding: const EdgeInsets.all(8.0),

        children: <Widget>[
          InkWell(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ListViewPage()));
            },
            child: new Card(
              child:Container(
                alignment: Alignment.center,
                child:Column(
                  children:<Widget>[
                    Icon(Icons.pageview,
                      color: Colors.red,
                    ),
                    Text("View talents",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 16),)
                  ], ),
              ),
            ),
          ),
          InkWell(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => password()));
            },
            child: new Card(
                  child:Container(
                    alignment: Alignment.center,
                  child:Column(
                  children:<Widget>[
                  Icon(Icons.add,
                    color: Colors.red,
                  ),
                    Text("Register a talent",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 16),)
                 ], ),
            ),
          ),
          ),
          InkWell(
            onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Aboutus()));
            },
            child: new Card(
              child:Container(
                alignment: Alignment.center,
                child:Column(
                  children:<Widget>[
                    Icon(Icons.account_box,
                      color: Colors.red,
                    ),
                    Text("About Us",style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 16),)
                  ], ),
              ),
            ),
          ),
    ],
    ),
    );
     }

}
