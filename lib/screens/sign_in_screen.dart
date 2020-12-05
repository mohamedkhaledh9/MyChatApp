import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/providers/change_them_data.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
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
      body: Form(
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
                hint: "Enter Your Email"),
            SizedBox(
              height: 20,
            ),
            CustomFormField(
                onClic: (value) {
                  password = value;
                },
                icon: Icons.lock,
                hint: "Enter Your Password"),
            SizedBox(
              height: 20,
            ),
            Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Colors.white,
                  onPressed: () async {
                    if (_globalKey.currentState.validate()) {
                      _globalKey.currentState.save();
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
                            Navigator.pushNamed(context, ChatRoom.id);
                          }
                        });
                      } catch (e) {
                        return Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    "Login",
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
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: Colors.black,
                onPressed: () {},
                child: Text(
                  "Sign With Google",
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
                    "Don't Have An Account ?   ",
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
                      "Register Now",
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
    );
  }
}
