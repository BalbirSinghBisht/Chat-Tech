import 'package:chattech/Pages/firstPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.deepOrangeAccent[100],
      seconds: 3,
      navigateAfterSeconds: new FirstPage(),
      title: new Text('Chat-Tech',textScaleFactor: 2,style: TextStyle(
        color: Colors.green[500],
      ),),
      image: new Image.asset('assets/logo.png'),
      loadingText: Text("Loading...."),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}