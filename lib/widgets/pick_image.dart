import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class PickImage extends StatefulWidget {
  final File _imagePickerPath;
  final Function(ImageSource src) _pickImage;

  PickImage(this._imagePickerPath, this._pickImage);

  @override
  _PickImageState createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: widget._imagePickerPath != null
                ? FileImage(widget._imagePickerPath)
                : null,
            backgroundColor: Colors.white70,
            radius: 70,
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              "Select Your Profile image".tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                onPressed: () async {
                  return await widget._pickImage(ImageSource.camera);
                },
                icon: Icon(
                  Icons.camera_alt,
                  size: 40,
                ),
                label: Text(
                  "Take Picture".tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              FlatButton.icon(
                onPressed: () async {
                  return await widget._pickImage(ImageSource.gallery);
                },
                icon: Icon(
                  Icons.crop_original,
                  size: 40,
                ),
                label: Text(
                  "Select From Gallery".tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
