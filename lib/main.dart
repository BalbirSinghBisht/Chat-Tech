import 'package:chattech/SplashScreen/splashscrn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  /*bool _isLoggedIn = false;
  @override
  void initState(){
    super.initState();
    _getUserLoggedInStatus();
  }
  _getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedIn().then((value) {
      if(value !=null){
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat-Tech",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Splash(),
    );
  }
}