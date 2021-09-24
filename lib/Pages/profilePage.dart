import 'package:chattech/Pages/HomePage.dart';
import 'package:chattech/Pages/authenticatePage.dart';
import 'package:chattech/Services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  late final String userName;
  late final String email;
  final AuthService _auth = AuthService();

  ProfilePage({required this.userName, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: TextStyle(
          color: Colors.white,fontSize: 27, fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(Icons.account_circle,size: 150,color: Colors.grey[700],),
            SizedBox(height: 15,),

            Text(userName,textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.bold)),
            SizedBox(height: 7,),

            ListTile(
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage())
                );
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.group),
              title: Text('Groups'),
            ),

            ListTile(
              selected: true,
              onTap: (){},
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),

            ListTile(
              onTap: () async{
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthenticatePage()),
                        (Route<dynamic> route) => false);
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.exit_to_app,color: Colors.red,),
              title: Text('Log Out', style: TextStyle(
                color: Colors.red
              ),),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.account_circle,size: 200,color: Colors.grey[700],),
              SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Full Name',style: TextStyle(fontSize: 17),),
                  Text(userName,style: TextStyle(fontSize: 17),)
                ],
              ),
              Divider(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Email', style: TextStyle(fontSize: 17),),
                  Text(email,style: TextStyle(fontSize: 17),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}