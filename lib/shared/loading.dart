import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrangeAccent[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Image.asset("assets/logo1.png"),
          SpinKitRing(
          color: Colors.blue.shade300,
          size: 50.0,
        ),
      ]
      ),
    );
  }
}