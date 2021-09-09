import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Authentication/otpPage.dart';
import 'Authentication/phone.dart';
import 'Pages/HomePage.dart';
import 'Pages/firstPage.dart';
import 'SplashScreen/splashscrn.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo Project",
      debugShowCheckedModeBanner: false,
      home: Splash(),
      routes: <String, WidgetBuilder>{
        '/otp': (BuildContext context) => new Otp(),
        '/phone': (BuildContext context) => new Phone(),
        '/homepage': (BuildContext context) => new HomePage(),
        '/firstpage': (BuildContext context) => new FirstPage(),
      },
    );
  }
}
