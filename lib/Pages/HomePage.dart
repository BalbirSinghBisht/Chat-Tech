import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat-Tech'),
        backgroundColor: Colors.deepOrangeAccent.shade100,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Text('Welcome to my Chat-Tech App',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold,
            fontSize: 30
          ),
        )
      )
    );
  }
}