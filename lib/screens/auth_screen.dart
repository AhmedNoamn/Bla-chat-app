import 'dart:io';

import 'package:bla_bla_chat/widgets/auth/authForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  UserCredential authresults;

  void _submitAuthForm(String email, String password, String userName,
      File image, bool isLogin, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authresults = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authresults = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final ref = FirebaseStorage.instance
            .ref('/image_user')
            .child(authresults.user.uid + '.jpg');
        await ref.putFile(image);

        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('/users')
            .doc(authresults.user.uid)
            .set({'userName': userName, 'password': password, 'imageUrl': url});
      }
    } on FirebaseAuthException catch (e) {
      String message = "error occurred";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      // ignore: deprecated_member_use
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
