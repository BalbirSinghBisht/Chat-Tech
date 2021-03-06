import 'package:chattech/Services/auth_service.dart';
import 'package:chattech/Services/database_service.dart';
import 'package:chattech/helper/helper_functions.dart';
import 'package:chattech/widgets/group_Tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authenticatePage.dart';
import 'profilePage.dart';
import 'searchPage.dart';

class HomePage extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage>{
  final AuthService _auth = AuthService();
  FirebaseUser _user;
  String _groupName;
  String _userName = '';
  String _email = '';
  Stream<dynamic> _groups;

  @override
  void initState(){
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  Widget noGroupWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              _popupDialog(context);
            },
            child: Icon(Icons.add_circle,color: Colors.grey[700],size: 75,),
          ),

          SizedBox(height: 20,),

          Text("You've not joined any group, tap on the 'add' icon to create"
              " a group or search for groups by tapping on the search "
              "button below.",textAlign: TextAlign.center,style: TextStyle(
              color: Colors.black54,fontSize: 18
          ),)
        ],
      ),
    );
  }

  Widget groupsList(){
    return StreamBuilder(
      stream: _groups,
      builder: (context,AsyncSnapshot<dynamic> snapshot){
        if(snapshot.hasData){
          if(snapshot.data != null){
            if(snapshot.data['groups'].length !=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                shrinkWrap: true,
                itemBuilder: (context,index){
                  int reqIndex = snapshot.data['groups'].length -index -1;
                  return GroupTile(
                      userName: snapshot.data['fullName'],
                      groupId: destructureId(snapshot.data['groups'][reqIndex]),
                      groupName: destructureName(snapshot.data['groups'][reqIndex])
                  );
                },
              );
            }
            else{
              return noGroupWidget();
            }
          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _getUserAuthAndJoinedGroups() async{
    _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserName().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots){
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        _email = value;
      });
    });
  }

  String destructureId(String res){
    return res.substring(0,res.indexOf('_'));
  }

  String destructureName(String res){
    return res.substring(res.indexOf('_')+1);
  }

  void _popupDialog(BuildContext context){
    Widget cancelButton = TextButton(
      child: Text("Cancel",style: TextStyle(
          color: Colors.white,
          fontSize: 18
      )),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );
    Widget createButton = TextButton(
      child: Text("Create",style: TextStyle(
        color: Colors.white,
        fontSize: 18
      )),
      onPressed: () async{
        if(_groupName != null){ // ignore: unnecessary_null_comparison
          await HelperFunctions.getUserName().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.deepOrangeAccent[100],
      title: Text("Create a Group",style: TextStyle(
        color: Colors.white,
        fontSize: 25
      )),
      content: TextFormField(
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white,width: 2.0)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF0889B6),width: 2.0)
          ),
        ),
        onChanged: (val){
          _groupName = val;
        },
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          height: 2
        ),
      ),
      actions: [
        cancelButton,
        createButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups', style: TextStyle(
            color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold
        )),
        backgroundColor: Colors.deepOrangeAccent[100],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.search, color: Colors.white, size: 25.0),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              }
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(Icons.account_circle,size: 150,color: Colors.grey),
            SizedBox(height: 15,),

            Text(_userName,textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 7,),

            ListTile(
              onTap: (){},
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.group),
              title: Text('Groups'),
            ),

            ListTile(
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) =>
                        ProfilePage(userName: _userName, email: _email)));
              },
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
              leading: Icon(Icons.exit_to_app, color: Colors.red,),
              title: Text("Log Out",style: TextStyle(color: Colors.red),),
            )
          ],
        ),
      ),
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white,size: 30),
        backgroundColor: Colors.grey[700],
        elevation: 0.0,
      ),
    );
  }
}