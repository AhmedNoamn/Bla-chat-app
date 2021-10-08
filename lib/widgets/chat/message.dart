import 'package:bla_bla_chat/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('/chat')
          .orderBy('sendTime', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final docs = snapShot.data.docs;
        final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
            reverse: true,
            itemCount: docs.isNotEmpty ? docs.length : 0,
            itemBuilder: (ctx, index) => MessageBubble(
                  docs[index]['text'],
                  docs[index]['userName'],
                  docs[index]['imageUrl'],
                  docs[index]['userId'] == user.uid,
                  key: ValueKey(docs[index].id),
                ));
      },
    );
  }
}
