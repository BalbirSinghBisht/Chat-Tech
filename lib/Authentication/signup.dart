import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController userController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool _toggleVisibility = true;
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Card(
        color: Colors.deepOrangeAccent[100],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
        ),
        child: SingleChildScrollView(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right:15, top: 10,bottom: 10),
              child: GestureDetector(
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: Colors.blue,
                  size: 30,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                  'Register', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black
              )
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.black54,
                      ),
                      hintText: "EMAIL",
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 40),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black54,
                      ),
                      hintText: "PASSWORD",
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                      suffixIcon: IconButton(
                        color: Colors.black54,
                        onPressed: () {
                          setState(() {
                            _toggleVisibility = !_toggleVisibility;
                          });
                        },
                        icon: _toggleVisibility
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                    ),
                    obscureText: _toggleVisibility,
                  ),
                ],
              ),
            ),
            GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  margin: EdgeInsets.only(left: 20,right: 20),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.white)]),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MaterialButton(
                      onPressed: () async {
                        setState(() {
                          showProgress = true;
                        });
                        try {
                          final newuser =
                              await mAuth.createUserWithEmailAndPassword(
                              email: emailController.text, password: passwordController.text);
                          if (newuser != null) {
                            Navigator.of(context).pushReplacementNamed('/homepage');
                            setState(() {
                              showProgress = false;
                            });
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            ),
            Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.only(top: 10),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'By creating an account or logging in you agree to YorLook ',
                          style: TextStyle(color: Colors.black,fontSize: 15)),
                      TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(color: Colors.pink,fontSize: 15),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Terms of Use"');
                            }),
                      TextSpan(text: ' and ',
                        style: TextStyle(color: Colors.black,fontSize: 15),),
                      TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Colors.pink,fontSize: 15),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Privacy Policy"');
                            }),
                      TextSpan(text: ' and consent to the collection and use of your',
                        style: TextStyle(color: Colors.black,fontSize: 15),),
                      TextSpan(text: ' personal information/sensitive personal data or information.',
                          style: TextStyle(color: Colors.black,fontSize: 15)),
                    ],
                  ),
                )
            )
          ],
          ),
        ),
        ),
      )
    );
  }
}