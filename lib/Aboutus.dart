import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tribal talent'), backgroundColor: Colors.green,

      ),
      backgroundColor: Colors.white70,
      body:Text("We provide details about tribal talents all over India and "
          "help organisers to reach them out. This way tribal people can earn for their living."),
    );
  }

}