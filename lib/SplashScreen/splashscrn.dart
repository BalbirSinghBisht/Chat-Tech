import 'package:chattech/Pages/HomePage.dart';
import 'package:chattech/Pages/authenticatePage.dart';
import 'package:chattech/helper/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
class Splash extends StatefulWidget{
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash>{
  bool _isLoggedIn = false;
  @override
  void initState(){
    super.initState();
    _getUserLoggedInStatus().whenComplete((){
      setState(() {});
    });
  }
  _getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedIn().then((value) {
      if(value !=null){
       setState((){
         _isLoggedIn = value;
       });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      backgroundColor: Colors.deepOrangeAccent[100],
      seconds: 3,
      navigateAfterSeconds: _isLoggedIn? HomePage() : AuthenticatePage(),
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