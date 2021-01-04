import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
import 'package:my_owen_chat_app/screens/status_screen.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:my_owen_chat_app/widgets/app_drawer.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  Stream<QuerySnapshot> userStream;
  String userName;
  String email;
  String userImageUrl;
  final _auth = FirebaseAuth.instance;
  QuerySnapshot userImage;
  getUserInfo() async {
    userImageUrl =
    await SharedPrefrencesFunctions.getUserImageUrlFromSharedPrefrences();
    Constants.myName =
    await SharedPrefrencesFunctions.getUserNameFromSharedPrefrences();
    Stream<QuerySnapshot> userData =
    await _dataBaseMethods.getUsers(Constants.myName);
    setState(() {
      userStream = userData;
      userName = Constants.myName;
    });
  }
  getCurrentUser() async {
    String mail = await _auth.currentUser.email;
    setState(() {
      email = mail;
    });
  }

  @override
  void initState() {
    getCurrentUser();
    getUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(userEmail: email,userImageUrl: userImageUrl,),
        appBar: AppBar(backgroundColor: kMainColor,
          title: Text("MyOwenChatApp"),
          bottom: TabBar(
            tabs: [
              Text("Chats".tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text("Status".tr,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ],
            onTap: (value){
              setState(() {
                currentPage=value;
              });
            },
          ),
        ),
        body: TabBarView(children: [
          ChatRoom(),
          StatusScreen(),
        ],),
      ),
    );
  }
}
