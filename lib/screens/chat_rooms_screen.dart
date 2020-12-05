import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/providers/change_them_data.dart';
import 'package:my_owen_chat_app/screens/conversation_screen.dart';
import 'package:my_owen_chat_app/screens/search_screen.dart';
import 'package:my_owen_chat_app/screens/sign_in_screen.dart';
import 'package:my_owen_chat_app/services/auth.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:provider/provider.dart';

class ChatRoom extends StatefulWidget {
  static String id = "ChatRoom";

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  Stream<QuerySnapshot> userStream;
  String userName;
  String email;
  String initialDropDown = "Light Mode";
  final _auth = FirebaseAuth.instance;

  getCurrentUser() async {
    email = await _auth.currentUser.email;
  }

  getUserInfo() async {
    Constants.myName =
        await SharedPrefrencesFunctions.getUserNameFromSharedPrefrences();
    Stream<QuerySnapshot> userData =
        await _dataBaseMethods.getUsers(Constants.myName);
    setState(() {
      userStream = userData;
      userName = Constants.myName;
    });
  }

  Widget userShow(String userName, String chatRoomId) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Text(
              "${userName.substring(0, 1).toUpperCase()}",
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(userName),
        ],
      ),
    );
  }

  Widget usersList() {
    return StreamBuilder(
        stream: userStream,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return ListView.builder(
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      userName: snapShot.data.docs[index]['chatroom_id']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRoomId: snapShot.data.docs[index]["chatroom_id"]);
                });
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: kMainColor,
              ),
            );
          }
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    ChangeThemData changeThemData = Provider.of(context);
    return Scaffold(
      drawer: Container(
        child: Drawer(
          child: ListView(
            children: [
              Container(
                child: DrawerHeader(
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            userName != null
                                ? userName.substring(0, 1).toUpperCase()
                                : "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          radius: 30,
                        ),
                        title: Text(
                          Constants.myName != null
                              ? Constants.myName.toUpperCase()
                              : "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(email == null ? "" : email),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
              ),
              ListTile(
                leading: GestureDetector(
                    onTap: () {
                      AlertDialog alert = AlertDialog(
                        buttonPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 22),
                        actionsPadding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                        contentPadding: EdgeInsets.all(30),
                        title: Text("Select Them"),
                        actions: [
                          Column(
                            children: [
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    changeThemData.setThem(ThemeData.light());
                                    SharedPrefrencesFunctions
                                        .saveUserModeSharedPrefrences(
                                            "Light Mode");
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text(
                                  "Light Mode",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: changeThemData.getThem() ==
                                              ThemeData.dark()
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    changeThemData.setThem(ThemeData.dark());
                                    SharedPrefrencesFunctions
                                        .saveUserModeSharedPrefrences(
                                            "Dark Mode");
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text(
                                  "Dark Mode",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: changeThemData.getThem() ==
                                              ThemeData.dark()
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                      return showDialog(
                          context: context, builder: (context) => alert);
                    },
                    child: Icon(Icons.menu_sharp)),
                title: Text(
                  "Them",
                ),
              ),
              ListTile(
                leading: GestureDetector(
                    onTap: () async {
                      AuthMethods _auth = AuthMethods();
                      await _auth.signOut();
                      Navigator.pushNamed(context, SignIn.id);
                      SharedPrefrencesFunctions
                          .saveUserLoggedInSharedPrefrences(false);
                    },
                    child: Icon(Icons.exit_to_app)),
                title: Text("Log Out"),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kMainColor,
        title: Text(
          "My Contacts",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kMainColor,
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, SearchPage.id);
          },
        ),
      ),
      body: Container(
        child: usersList(),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomTile({this.userName, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(userName.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(userName.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
