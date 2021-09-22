import 'package:chattech/Pages/HomePage.dart';
import 'package:chattech/Services/auth_service.dart';
import 'package:chattech/Services/database_service.dart';
import 'package:chattech/helper/helper_functions.dart';
import 'package:chattech/shared/constants.dart';
import 'package:chattech/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget{
  late final Function toggleView;

  SignIn({required this.toggleView});

  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn>{
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  String email='';
  String password='';
  String error='';

  _onSignIn() async {
    if(_formkey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await _auth.registerWithEmail(email, password).then((result) async{
        if(result != null){
          QuerySnapshot userInputSnapshot = await DatabaseService(uid: '').getUserData(email);

          await HelperFunctions.saveUserLoggedIn(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(
              userInputSnapshot.docs[0].get('FullName')
          );
          print("SignedIn");
          await HelperFunctions.getUserLoggedIn().then((value){
            print("Logged In: $value");
          });
          await HelperFunctions.getUserEmail().then((value){
            print("Email: $value");
          });
          await HelperFunctions.getUserName().then((value){
            print("Full Name: $value");
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        }
        else{
          setState(() {
            error = 'Error SignIn!!!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Loading(): Scaffold(
      body: Form(
        key: _formkey,
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 80),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Create or Join Groups",style: TextStyle(
                    color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 30,),
                  Text('Sign In',style: TextStyle(
                    color: Colors.white,fontSize: 25
                  ),),
                  SizedBox(height: 20,),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: textInputDecoration.copyWith(labelText: 'Email'),
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0_9,a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").
                      hasMatch(val!) ? null:"Please Enter Valid Email";
                    },
                    onChanged: (val){
                      setState(() {
                        email=val;
                      });
                    },
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: textInputDecoration.copyWith(labelText: 'Password'),
                    validator: (val) => val!.length < 8 ? 'Password Not Strong Enough':null,
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.deepOrangeAccent[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Text('Sign In',style: TextStyle(
                        color: Colors.white,fontSize: 16
                      ),),
                      onPressed: (){
                        _onSignIn();
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(color: Colors.white,fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register here',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap = (){
                            widget.toggleView();
                          }
                        )
                      ]
                    )
                  ),
                  SizedBox(height: 10,),
                  Text(error, style: TextStyle(color: Colors.red,fontSize: 14),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}