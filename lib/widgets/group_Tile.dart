import 'package:chattech/Pages/chatPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatelessWidget{
  late final String userName;
  late final String groupId;
  late final String groupName;

  GroupTile({
    required this.userName,
    required this.groupId,
    required this.groupName
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            ChatPage(groupId: groupId, userName: userName, groupName: groupName,)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.deepOrangeAccent[100],
            child: Text(
              groupName.substring(0,1).toUpperCase(), textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          title: Text(groupName,style: TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text("Join the conversation as $userName",
          style: TextStyle(fontSize: 14),),
        ),
      ),
    );
  }
}