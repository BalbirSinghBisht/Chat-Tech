import 'package:chattech/Pages/chatPage.dart';
import 'package:chattech/Services/database_service.dart';
import 'package:chattech/helper/helper_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget{
  @override
  _Search createState() => _Search();
}

class _Search extends State<SearchPage>{
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  FirebaseUser _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    _getCurrentUserNameAndUid();
  }

  _getCurrentUserNameAndUid() async{
    await HelperFunctions.getUserName().then((value) {
      _userName = value;
    });
    _user = await FirebaseAuth.instance.currentUser(); // ignore: await_only_futures
  }

  _initiateSearch() async{
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searchEditingController.text).then((snapshot){
        searchResultSnapshot = snapshot;
        //print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }
  void _showScaffold(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrangeAccent[100],
          duration: Duration(milliseconds: 1500),
          content: Text(message, textAlign: TextAlign.center,style: TextStyle(fontSize: 17),),
      )
    );
  }
  _joinValueInGroup(String userName,String groupId,String groupName,String admin) async{
    bool value = await DatabaseService(uid: _user.uid).isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }
  Widget groupList(){
    return hasUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchResultSnapshot.documents.length,
      itemBuilder: (context,index){
        return groupTile(
          _userName,
          searchResultSnapshot.documents[index].data["groupId"],
          searchResultSnapshot.documents[index].data["groupName"],
          searchResultSnapshot.documents[index].data["admin"],
        );
      },
    ):Container();
  }

  Widget groupTile(String userName,String groupId,String groupName,String admin){
    _joinValueInGroup(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.deepOrangeAccent[100],
        child: Text(groupName.substring(0,1).toUpperCase(),
        style: TextStyle(color: Colors.white),),
      ),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text("Admin: $admin"),
      trailing: InkWell(
        onTap: () async{
          await DatabaseService(uid: _user.uid).togglingGroupJoin(groupId, groupName, userName);
          if(_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            _showScaffold('Successfully Joined the Group "$groupName"');
            Future.delayed(Duration(milliseconds: 2000), () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ChatPage(
                          groupId: groupId,
                          userName: userName,
                          groupName: groupName)
              ));
            });
          }
          else{
            setState(() {
              _isJoined = !_isJoined;
            });
            _showScaffold('Left the Group "$groupName"');
          }
        },
        child: _isJoined ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black87,
            border: Border.all(
              color: Colors.white,
              width: 1.0
            )
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text('Joined',style: TextStyle(color: Colors.white),),
        ) : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.deepOrangeAccent[100]
          ),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text("Join",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.deepOrangeAccent[100],
        title: Text('Search',style: TextStyle(
          color: Colors.white,fontSize: 27,fontWeight: FontWeight.bold
        ),),
      ),
      body: Container(
        color: Colors.deepOrangeAccent[100],
        child: Column(
          children: [
            Divider(height: 10,thickness: 2),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                shape: BoxShape.rectangle,
                color: Colors.grey
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchEditingController,
                        style: TextStyle(
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Groups...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                          ),
                          border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      _initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: Icon(Icons.search,color: Colors.black,),
                    ),
                  )
                ],
              ),
            ),
            isLoading ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
                : groupList()
          ],
        ),
      ),
    );
  }
}