import 'package:chattech/Authentication/phone.dart';
import 'package:chattech/Authentication/signin.dart';
import 'package:chattech/Authentication/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget{
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Material(
        color: Colors.deepOrangeAccent[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: Image.asset('assets/logo.png',
                fit: BoxFit.contain,),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.white)]),
              child: Align(
                alignment: Alignment.centerLeft,
                child: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'LOGIN',
                        style: TextStyle(color: Colors.lightBlue[200], fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SignInPage(),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.white)]),
              child: Align(
                alignment: Alignment.centerLeft,
                child: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'REGISTER',
                        style: TextStyle(color: Colors.lightBlue[200], fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SignUpPage(),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.white)]),
              child: Align(
                alignment: Alignment.centerLeft,
                child: MaterialButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'PHONE',
                        style: TextStyle(color: Colors.lightBlue[200], fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Phone(),
                    );
                  },
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}