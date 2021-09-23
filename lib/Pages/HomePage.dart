import 'package:chattech/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>{
  final AuthService _auth = AuthService();
  late User _user;
  late String _groupName;
  String _userName = '';
  String _email = '';
  late String _groups;

  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat-Tech'),
        backgroundColor: Colors.deepOrangeAccent.shade100,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: Icon(
                      CupertinoIcons.add_circled,
                      color: Colors.grey, size: 70.0
                  )
              ),
              SizedBox(height: 20.0),
              Text("You've not joined any group, tap on the 'add' icon to create"
                  " a group or search for groups by tapping on the search "
                  "button below.",textAlign: TextAlign.center,style: TextStyle(
                color: Colors.grey,fontSize: 18
              ),),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.grey,
        splashColor: Colors.deepOrangeAccent.shade100,
        elevation: 0.0,
      ),
    );
  }
}