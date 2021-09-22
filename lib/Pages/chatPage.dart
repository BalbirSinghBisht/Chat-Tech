import 'package:chattech/Services/database_service.dart';
import 'package:chattech/widgets/message_Tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{
  late final String groupId;
  late final String userName;
  late final String groupName;

  ChatPage({
    required this.groupId,
    required this.userName,
    required this.groupName
  });
  @override
  _ChatPage createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage>{
  late Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();
  @override
  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: (snapshot.data as QuerySnapshot).docs.length,
          itemBuilder: (context,index){
            return MessageTile(
                message: (snapshot.data as QuerySnapshot).docs[index].get("message"),
                sender: (snapshot.data as QuerySnapshot).docs[index].get("sender"),
                sentByMe: widget.userName == (snapshot.data as QuerySnapshot).docs[index].get("sender"));
            },
        ) :
        Container();
      },
    );
  }
  _sendMessage(){
    if(messageEditingController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      DatabaseService(uid: '').sendMsg(widget.groupId,chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }
  @override
  void initState(){
    super.initState();
    DatabaseService(uid: '').getChats(widget.groupId).then((val){
      setState(() {
        _chats = val;
      });
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName,style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.black87,
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                color: Colors.grey[700],
                child: Row(
                  children: <Widget>[
                    Expanded(child: TextField(
                      controller: messageEditingController,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      decoration: InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 17
                        ),
                        border: InputBorder.none
                      ),
                    )),
                    SizedBox(width: 13.0,),
                    GestureDetector(
                      onTap: (){
                        _sendMessage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.deepOrangeAccent[100],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.deepOrangeAccent[100],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}