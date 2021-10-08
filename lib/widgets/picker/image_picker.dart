import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePicFn;

  UserImagePicker(this.imagePicFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource src) async {
    final pickedImageSource = await _picker.getImage(
        source: src, maxHeight: 150, maxWidth: 150, imageQuality: 30);
    if (pickedImageSource != null) {
      setState(() {
        _pickedImage = File(pickedImageSource.path);
      });
      widget.imagePicFn(_pickedImage);
    } else {
      print("No Image Selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              icon: Icon(Icons.photo_camera),
              label: Text(
                "Pick an Image\nFrom Camera",
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            TextButton.icon(
              icon: Icon(Icons.photo_outlined),
              label: Text(
                "Pick an Image\nFrom Gallery",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        )
      ],
    );
  }
}
