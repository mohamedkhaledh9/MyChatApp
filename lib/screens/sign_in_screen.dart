import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/providers/change_them_data.dart';
import 'package:my_owen_chat_app/screens/home_screen.dart';
import 'package:my_owen_chat_app/screens/sign_up_screen.dart';
import 'package:my_owen_chat_app/services/auth.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:my_owen_chat_app/widgets/custom_text_field.dart';
import 'package:my_owen_chat_app/widgets/logo.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  static String id = "SignIn";

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email, password;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  AuthMethods _authMethods = AuthMethods();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  QuerySnapshot snapshotUserInfo;
  bool isLoading = false;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    ChangeThemData changeThemData = Provider.of(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("My Owen Chat App"),
        backgroundColor: kMainColor,
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              AppLogo(),
              SizedBox(
                height: 15,
              ),
              CustomFormField(
                  onClic: (value) {
                    email = value;
                  },
                  icon: Icons.mail,
                  hint: "Enter Your Email".tr),
              SizedBox(
                height: 20,
              ),
              CustomFormField(
                onClic: (value) {
                  password = value;
                },
                icon: Icons.lock,
                hint: "Enter Your Password".tr,
                showPass: showPassword,
                icon2: IconButton(
                  icon: Icon(showPassword == false
                      ? Icons.visibility
                      : Icons.visibility_off),
                  color: kMainColor,
                  onPressed: () {
                    if (showPassword == false) {
                      setState(() {
                        showPassword = true;
                      });
                    } else {
                      setState(() {
                        showPassword = false;
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Colors.white,
                    onPressed: () async {
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await _authMethods
                              .signInWithEmailAndPassword(email, password)
                              .then((value) async {
                            if (value != null) {
                              snapshotUserInfo = await _dataBaseMethods
                                  .getUsersByUserEmail(email);
                              SharedPrefrencesFunctions
                                  .saveUserEmailSharedPrefrences(
                                      snapshotUserInfo.docs[0].data()["email"]);
                              SharedPrefrencesFunctions
                                  .saveUserNameSharedPrefrences(
                                      snapshotUserInfo.docs[0].data()["name"]);
                              SharedPrefrencesFunctions
                                  .saveUserLoggedInSharedPrefrences(true);
                              SharedPrefrencesFunctions
                                  .saveImageUrlSharedPrefrences(snapshotUserInfo
                                      .docs[0]
                                      .data()["image_url"]);

                              Get.offAll(HomeScreen());
                            }
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          return Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message),
                            ),
                          );
                        }
                      }
                    },
                    child: Text(
                      "Login".tr,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
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
                        isLoading = true;
                      });
                      final user = await _authMethods.signInWithGoogle();
                      snapshotUserInfo = await _dataBaseMethods
                          .getUsersByUserEmail(user.user.email);
                      SharedPrefrencesFunctions.saveUserEmailSharedPrefrences(
                          snapshotUserInfo.docs[0].data()["email"]);
                      SharedPrefrencesFunctions.saveUserNameSharedPrefrences(
                          snapshotUserInfo.docs[0].data()["name"]);
                      SharedPrefrencesFunctions
                          .saveUserLoggedInSharedPrefrences(true);
                      SharedPrefrencesFunctions.saveImageUrlSharedPrefrences(
                          snapshotUserInfo.docs[0].data()["image_url"]);

                      Get.offAll(HomeScreen());
                      setState(() {
                        isLoading = false;
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      Get.snackbar("error !!!".tr,
                          "Failed Login !!! Check your regesteration ...".tr,
                          snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red);

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
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      "Don't Have An Account ?".tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, SignUp.id);
                      },
                      child: Text(
                        "Register Now".tr,
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
    );
  }
}
