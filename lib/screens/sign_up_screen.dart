import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
import 'package:my_owen_chat_app/screens/sign_in_screen.dart';
import 'package:my_owen_chat_app/services/auth.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:my_owen_chat_app/widgets/custom_text_field.dart';
import 'package:my_owen_chat_app/widgets/logo.dart';

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text("Register Page"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: kMainColor,
      body: Form(
        key: _globalKey,
        child: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              AppLogo(),
              SizedBox(
                height: 15,
              ),
              CustomFormField(
                  onClic: (value) {
                    userName = value;
                  },
                  icon: Icons.person,
                  hint: "Enter User Name"),
              SizedBox(
                height: 20,
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
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.white,
                    onPressed: () async {
                      if (_globalKey.currentState.validate()) {
                        _globalKey.currentState.save();
                        Map<String, String> userInfo = {
                          "email": email,
                          "name": userName,
                        };
                        SharedPrefrencesFunctions.saveUserEmailSharedPrefrences(
                            email);
                        SharedPrefrencesFunctions.saveUserNameSharedPrefrences(
                            userName);
                        try {
                          await _authMethods.signUpWithEmailAndPassword(
                              email, password);

                          _dataBaseMethods.uploadUserInfo(userInfo);
                          SharedPrefrencesFunctions
                              .saveUserLoggedInSharedPrefrences(true);
                          Navigator.pushNamed(context, ChatRoom.id);
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
                      " Confirm ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Have An Account ?   ",
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
                        "Login Now",
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
