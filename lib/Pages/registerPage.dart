import 'package:chattech/Pages/HomePage.dart';
import 'package:chattech/Services/auth_service.dart';
import 'package:chattech/helper/helper_functions.dart';
import 'package:chattech/shared/constants.dart';
import 'package:chattech/shared/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  late final Function toggleView;
  RegisterPage({required this.toggleView});

  @override
  _Register createState() => _Register();
}

class _Register extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  _onRegister() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await _auth.registerWithEmail(fullName ,email, password).then((result) async{
        if(result != null){
          await HelperFunctions.saveUserLoggedIn(true);
          await HelperFunctions.saveUserEmail(email);
          await HelperFunctions.saveUserName(fullName);

          print("Registered");
          await HelperFunctions.getUserLoggedIn().then((value) {
            print("Logged In: $value");
          });
          await HelperFunctions.getUserEmail().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserName().then((value) {
            print("FullName: $value");
          });
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage())
          );
        }
        else{
          setState(() {
            error = "Error While Registering The User !!!";
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loading() : Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.deepOrangeAccent[100],
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 80),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Create or Join Groups",style: TextStyle(
                    color: Colors.white,fontSize: 50,fontWeight: FontWeight.bold
                  ),textAlign: TextAlign.center,),
                  SizedBox(height: 30,),

                  Text("Register", style: TextStyle(
                    color: Colors.black54,fontSize: 25
                  ),),
                  SizedBox(height: 20,),

                  TextFormField(
                    style: TextStyle(color: Colors.black54),
                    decoration: textInputDecoration.copyWith(labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: (val){
                      setState(() {
                        fullName = val;
                      });
                    },
                  ),
                  SizedBox(height: 15,),

                  TextFormField(
                    style: TextStyle(color: Colors.black54),
                    decoration: textInputDecoration.copyWith(labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val!)? null : "Please Enter a valid Email";
                    },
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 15,),

                  TextFormField(
                    style: TextStyle(color: Colors.black54),
                    decoration: textInputDecoration.copyWith(labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black54),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (val) => val!.length < 8 ? "Password Not Strong Enough" : null,
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        primary: Colors.blue[300]
                      ),
                      child: Text("Register",style: TextStyle(
                        color: Colors.white,fontSize: 16,)),
                      onPressed: (){
                        _onRegister();
                      },
                    ),
                  ),
                  SizedBox(height: 20,),

                  Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.black,fontSize: 18),
                      children: <TextSpan>[
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
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

                  Text(error,style: TextStyle(
                    color: Colors.red,fontSize: 18
                  ),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}