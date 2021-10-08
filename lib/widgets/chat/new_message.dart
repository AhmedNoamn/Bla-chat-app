import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('/users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('/chat').add({
      'text': _enteredMessage,
      'sendTime': Timestamp.now(),
      'userName': userData['userName'],
      'imageUrl': userData['imageUrl'],
      'userId': user.uid,
    });
    _controller.clear();
    setState(() {
      _enteredMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: TextStyle(color: Colors.black),
                hintText: "Send a message ...",
              ),
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: () => _enteredMessage.isEmpty ? null : _sendMessage())
        ],
      ),
    );
  }
}
