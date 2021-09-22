import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget{
  late final String message;
  late final String sender;
  late final bool sentByMe;

  MessageTile({
    required this.message,
    required this.sender,
    required this.sentByMe
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: sentByMe ? 0 : 24,
          right: sentByMe ? 24 : 0),
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sentByMe? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.symmetric(vertical: 17,horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ) :
          BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomRight: Radius.circular(23)
          ),
          color: sentByMe ? Colors.deepOrangeAccent.shade100 : Colors.grey.shade700
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              sender.toUpperCase(),textAlign: TextAlign.start,
              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black,
              letterSpacing: -0.4),
            ),
            SizedBox(height: 8,),
            Text(
              message,textAlign: TextAlign.start,style: TextStyle(
              fontSize: 15,color: Colors.white
            ),
            )
          ],
        ),
      ),
    );
  }
}