import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
import 'package:my_owen_chat_app/screens/home_screen.dart';
import 'package:my_owen_chat_app/screens/sign_in_screen.dart';
import 'package:my_owen_chat_app/services/auth.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:my_owen_chat_app/widgets/custom_text_field.dart';
import 'package:my_owen_chat_app/widgets/divider.dart';
import 'package:my_owen_chat_app/widgets/logo.dart';
import 'package:my_owen_chat_app/widgets/pick_image.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constans.dart';

class SignUp extends StatefulWidget {
  static String id = "SignUp";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String userName, email, password;
  AuthMethods _authMethods = AuthMethods();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  File _imagePickerPath;
  final ImagePicker _picker = ImagePicker();
  bool isLoadin = false;
  bool showPassword = false;

  void _pickImage(ImageSource src) async {
    final pickedImageFile = await _picker.getImage(
        source: src, maxWidth: 500, maxHeight: 500, imageQuality: 70);
    if (pickedImageFile != null) {
      setState(() {
        _imagePickerPath = File(pickedImageFile.path);
      });
    } else {
      print("no image selected !!");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Owen Chat App"),
        backgroundColor: kMainColor,
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: isLoadin,
        child: Form(
          key: _globalKey,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                // AppLogo(),
                SizedBox(
                  height: 30,
                ),
                PickImage(_imagePickerPath, _pickImage),
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                    onClic: (String value) {
                      userName = value.removeAllWhitespace;
                    },
                    icon: Icons.person,
                    hint: "Enter User Name".tr),
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                    onClic: (String value) {
                      email = value.removeAllWhitespace;
                    },
                    icon: Icons.mail,
                    hint: "Enter Your Email".tr),
                SizedBox(
                  height: 10,
                ),
                CustomFormField(
                  onClic: (String value) {
                    password = value.removeAllWhitespace;
                  },
                  icon: Icons.lock,
                  hint: "Enter Your Password".tr,
                  showPass: showPassword,
                  icon2: IconButton(
                    icon: Icon(
                      showPassword == false
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    color: kMainColor,
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.white,
                      onPressed: () async {
                        if (_imagePickerPath != null) {
                          if (_globalKey.currentState.validate()) {
                            _globalKey.currentState.save();
                            setState(() {
                              isLoadin = true;
                            });
                            try {
                              final authResult = await _authMethods
                                  .signUpWithEmailAndPassword(email, password);
                              SharedPrefrencesFunctions
                                  .saveUserEmailSharedPrefrences(
                                      email.removeAllWhitespace);
                              SharedPrefrencesFunctions
                                  .saveUserNameSharedPrefrences(
                                      userName.removeAllWhitespace);
                              final ref = FirebaseStorage.instance
                                  .ref()
                                  .child("users_images")
                                  .child(authResult.user.uid + '.jpg');
                              await ref.putFile(_imagePickerPath);
                              final url = await ref.getDownloadURL();

                              Map<String, String> userInfo = {
                                "email": email.removeAllWhitespace,
                                "name": userName.removeAllWhitespace,
                                "image_url": url,
                              };
                              _dataBaseMethods.uploadUserInfo(userInfo);
                              SharedPrefrencesFunctions
                                  .saveImageUrlSharedPrefrences(url);
                              SharedPrefrencesFunctions
                                  .saveUserLoggedInSharedPrefrences(true);
                              setState(() {
                                isLoadin = false;
                              });
                              Get.offAll(HomeScreen());
                            } catch (e) {
                              setState(() {
                                isLoadin = false;
                              });
                              return Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                ),
                              );
                            }
                          }
                        } else {
                          print("No Image Sellected");
                          return Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("No Image Sellected".tr),
                            ),
                          );
                        }
                      },
                      child: Text(
                        " Confirm ".tr,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.black,
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoadin = true;
                        });
                        final user = await _authMethods.signInWithGoogle();
                        Map<String, String> userInfo = {
                          "email": user.user.email,
                          "name": user.user.displayName.removeAllWhitespace,
                          "image_url": user.user.photoURL,
                        };
                        _dataBaseMethods.uploadUserInfo(userInfo);
                        SharedPrefrencesFunctions.saveUserEmailSharedPrefrences(
                            user.user.email);
                        SharedPrefrencesFunctions.saveUserNameSharedPrefrences(
                            user.user.displayName.removeAllWhitespace);
                        SharedPrefrencesFunctions.saveImageUrlSharedPrefrences(
                            user.user.photoURL);
                        SharedPrefrencesFunctions
                            .saveUserLoggedInSharedPrefrences(true);
                        Get.offAll(HomeScreen());
                      } catch (e) {
                        setState(() {
                          isLoadin = false;
                        });
                        Get.snackbar("error !!!", "Failed LOgin ...");
                      }
                    },
                    child: Text(
                      "Sign With Google".tr,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Have An Account ?  ".tr,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignIn.id);
                        },
                        child: Text(
                          "Login Now".tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
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
    );
  }
}
