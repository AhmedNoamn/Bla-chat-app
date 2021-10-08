import 'dart:io';
import '../picker/image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String userName,
      File image, bool isLogin, BuildContext ctx) submitFunc;
  final bool isLoading;
  AuthForm(this.submitFunc, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email;
  String _password;
  String _userName;
  File _imagePIcker;
  void _pickedImage(File pickedImage) {
    _imagePIcker = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _imagePIcker == null) {
      // ignore: deprecated_member_use
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please Select Image"),
        backgroundColor: Theme.of(context).primaryColor,
      ));
      return;
    }
    if (isValid) {
      _formKey.currentState.save();

      widget.submitFunc(
          _email, _password, _userName, _imagePIcker, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(14),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: ValueKey('email'),
                  validator: (val) {
                    if (val.isEmpty || !val.contains('@')) {
                      return "Please Enter a Valid Email Address";
                    }
                    return null;
                  },
                  onChanged: (val) => _email = val,
                  onSaved: (val) => _email = val,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email Address"),
                ),
                if (!_isLogin)
                  TextFormField(
                    autocorrect: true,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.words,
                    key: ValueKey('username'),
                    validator: (val) {
                      if (val.isEmpty || val.length < 4) {
                        return "Please Enter at leaset 4 characters";
                      }
                      return null;
                    },
                    onChanged: (val) => _userName = val,
                    //onSaved: (val) => _userName = val,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (val) {
                    if (val.isEmpty || val.length < 6) {
                      return "Please Enter at least 6 characters";
                    }
                    return null;
                  },
                  onChanged: (val) => _password = val,
                  // onSaved: (val) => _password = val,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "PassWord"),
                  obscureText: true,
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                      onPressed: _submit,
                      child: Text(_isLogin ? "Log In" : "Sign Up")),
                if (!widget.isLoading)
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle:
                          TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    child: Text(_isLogin
                        ? "Create new account"
                        : "I already have an account"),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
