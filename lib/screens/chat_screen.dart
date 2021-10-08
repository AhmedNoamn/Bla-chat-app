import 'package:bla_bla_chat/widgets/chat/message.dart';
import 'package:bla_bla_chat/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bla Chat"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text("Logout"),
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Message()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
