import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:get/get.dart';
import 'dart:io';
class ShowMyStatus extends StatefulWidget {
  static String id = "ShowStatus";

  @override
  _ShowMyStatusState createState() => _ShowMyStatusState();
}

class _ShowMyStatusState extends State<ShowMyStatus> {
  Stream statusStream;
  String userImageUrl;
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  final ImagePicker _imagePicker = ImagePicker();
  FirebaseAuth _authMethods = FirebaseAuth.instance;

  File _imagePickerPath;
  String userEmail;
  String uId;

  status() async {
    userImageUrl =
        await SharedPrefrencesFunctions.getUserImageUrlFromSharedPrefrences();
    await _dataBaseMethods.getMyStatus(Constants.myName).then(
      (status) {
        setState(() {
          statusStream = status;
        });
      },
    );
  }

  Widget showStatus() {
    return StreamBuilder(
        stream: statusStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              child: Image(
                                width: Get.width,
                                height: Get.height,
                                image: NetworkImage(
                                    snapshot.data.docs[index]["state"]),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: userImageUrl == null
                                      ? null
                                      : NetworkImage(userImageUrl),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        Constants.myName.toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,color: Colors.white),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        snapshot.data.docs[index]["state_time"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child:Text("No Status ..."),

            );
          }
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

  @override
  void initState() {
    status();
    getCurrentUser();
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
      appBar: AppBar(
        title: Text("My Status".tr),
        backgroundColor: kMainColor,
      ),
      body: showStatus(),
    );
  }
}
