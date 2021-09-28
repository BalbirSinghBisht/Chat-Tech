import 'package:chattech/Pages/sign_in_page.dart';
import 'package:flutter/cupertino.dart';
import 'registerPage.dart';

class AuthenticatePage extends StatefulWidget{
  @override
  _Authenticate createState() => _Authenticate();
}

class _Authenticate extends State<AuthenticatePage>{
  bool _showSignIn = true;
  void _toggleView(){
    setState(() {
      _showSignIn= !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_showSignIn){
      return SignIn(toggleView: _toggleView);
    }
    else{
      return RegisterPage(toggleView: _toggleView);
    }
  }
}