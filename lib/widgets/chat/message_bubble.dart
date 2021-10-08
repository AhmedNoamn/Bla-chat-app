import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final key;
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;

  const MessageBubble(this.message, this.userName, this.userImage, this.isMe,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [

      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[

          Container(
            decoration: BoxDecoration(
                color: isMe ? Colors.green : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                  bottomLeft: isMe ? Radius.circular(14) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
                )),
            width: 140,
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              crossAxisAlignment:
                  !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black ),

                ),
                Text(
                  message,
                  style: TextStyle(color: Colors.black),
                  textAlign:TextAlign.start,
                ),
              ],
            ),
          )
        ],
      ), Positioned(
        top: 0,
        left: !isMe ? 10 : null,
        right: isMe ? 10 : null,
        child: CircleAvatar(
          backgroundImage: NetworkImage(userImage),
        ),
      ),

    ]);
  }
}
