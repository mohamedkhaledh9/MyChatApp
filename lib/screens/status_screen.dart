import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/screens/show_friends_status.dart';
import 'package:my_owen_chat_app/screens/show_my_status.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:my_owen_chat_app/widgets/divider.dart';
import 'package:get/get.dart';

class StatusScreen extends StatefulWidget {
  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String userImageUrl;
  final ImagePicker _imagePicker = ImagePicker();
  FirebaseAuth _authMethods = FirebaseAuth.instance;
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  File _imagePickerPath;
  String userEmail;
  String uId;
  Stream statusStream;

  status() async {
    await _dataBaseMethods.getStatus(Constants.myName).then((status) {
      setState(() {
        statusStream = status;
      });
    });
  }

  getCurrentUser() async {
    String mail = await _authMethods.currentUser.email;
    String uid = await _authMethods.currentUser.uid;
    setState(() {
      userEmail = mail;
      uId = uid;
    });
  }

  void _pickImage(ImageSource src) async {
    final pickedImageFile = await _imagePicker.getImage(
      source: src,
      maxHeight: 500,
      maxWidth: 500,
      imageQuality: 70,
    );
    if (pickedImageFile != null) {
      setState(() {
        _imagePickerPath = File(pickedImageFile.path);
      });
    } else {
      print("no image selected !!");
    }
  }

  getImageUrl() async {
    await SharedPrefrencesFunctions.getUserImageUrlFromSharedPrefrences()
        .then((value) {
      setState(() {
        userImageUrl = value;
      });
    });
  }

  Widget showStatus() {
    return StreamBuilder(
        stream: statusStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  if (snapshot.data.docs.length != null) {
                    return statusTile(
                        snapshot.data.docs[index]["state"],
                        snapshot.data.docs[index]["name"],
                        snapshot.data.docs[index]["userEmail"]);
                  } else {
                    return Center(child: Text("No Status Updates"));
                  }
                });
          } else {
            return Center(
              child: Text("No Status"),
            );
          }
        });
  }

  @override
  void initState() {
    getImageUrl();
    getCurrentUser();
    status();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: null,
              backgroundColor: kMainColor,
              onPressed: () async {
                await _pickImage(ImageSource.gallery);
                final ref = FirebaseStorage.instance
                    .ref()
                    .child("userStatus_image")
                    .child(uId + '.jpg');
                await ref.putFile(_imagePickerPath);
                final url = await ref.getDownloadURL();
                Map<String, dynamic> stateSenderInfo = {
                  "userEmail": userEmail,
                  "state": url,
                  "name": Constants.myName,
                  "image_url": userImageUrl,
                  "state_time": DateTime.now()
                      .toIso8601String()
                      .replaceAll("T", "  at ")
                      .substring(0, 23),
                };
                await _dataBaseMethods.creatState(stateSenderInfo);
              },
              child: Icon(
                Icons.crop_original,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: null,
              backgroundColor: kMainColor,
              onPressed: () async {
                await _pickImage(ImageSource.camera);
                final ref = FirebaseStorage.instance
                    .ref()
                    .child("userStatus_image")
                    .child(uId + '.jpg');
                await ref.putFile(_imagePickerPath);
                final url = await ref.getDownloadURL();
                Map<String, dynamic> stateSenderInfo = {
                  "userEmail": userEmail,
                  "state": url,
                  "name": Constants.myName,
                  "image_url": userImageUrl,
                  "state_time": DateTime.now()
                      .toIso8601String()
                      .replaceAll("T", "  at ")
                      .substring(0, 23),
                };
                await _dataBaseMethods.creatState(stateSenderInfo);
              },
              child: Icon(
                Icons.camera_alt,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              print("done");
              Get.to(ShowMyStatus());
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          backgroundImage: _imagePickerPath == null
                              ? userImageUrl == null
                                  ? null
                                  : NetworkImage(userImageUrl)
                              : FileImage(_imagePickerPath),
                          radius: 35,
                        ),
                        Positioned(
                          top: 35,
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            child: Icon(
                              Icons.add,
                            ),
                            radius: 12,
                            backgroundColor: kMainColor,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MyStatus".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Tap To Show Your Status".tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CustomDivider(),
          SizedBox(
            height: 10,
          ),
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Row(children: [
             Text(
               "Recent Updates".tr,
               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
             ),
             SizedBox(width: 10,),
             Icon(Icons.arrow_circle_down),
           ],),
         ),
          SizedBox(
            height: 10,
          ),
          Expanded(child: showStatus()),
        ],
      ),
    );
  }

  Widget statusTile(String imageUrl, String stateSender, String email) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ShowFriendsStatus.id,
            arguments: stateSender);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.blueGrey),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage:
                    imageUrl == null ? null : NetworkImage(imageUrl),
                backgroundColor: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                stateSender,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
