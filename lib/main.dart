import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tribal_repository/home.dart';

void main() {
  runApp(new MaterialApp(
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => new home()
    },
  ));
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 5);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Image.asset('images/The-Indigenous-Colour-of-India-The-Indian-Tribes.png',fit:BoxFit.fill),
    );
  }
}