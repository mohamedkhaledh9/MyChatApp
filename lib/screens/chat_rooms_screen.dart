import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/providers/change_them_data.dart';
import 'package:my_owen_chat_app/screens/conversation_screen.dart';
import 'package:my_owen_chat_app/screens/search_screen.dart';
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
  String userImageUrl;

  final _auth = FirebaseAuth.instance;

  getUserInfo() async {
    await SharedPrefrencesFunctions.getUserEmailFromSharedPrefrences();
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
                shrinkWrap: true,
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  if (snapShot.data.docs.length != null) {
                    return ChatRoomTile(
                      userName: snapShot.data.docs[index]['chatroom_id']
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      chatRoomId: snapShot.data.docs[index]["chatroom_id"],
                      otherName: snapShot.data.docs[index]["otherUserName"],
                      imageUrl: snapShot.data.docs[index]["otherUserName"] ==
                              Constants.myName
                          ? snapShot.data.docs[index]["myImageUrl"]
                          : snapShot.data.docs[index]["otherUserImageUrl"],
                    );
                  } else {
                    return Center(
                      child: Text("Loading....."),
                    );
                  }
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

class ChatRoomTile extends StatefulWidget {
  final String userName;
  final String chatRoomId;
  final String imageUrl;
  final String otherName;

  ChatRoomTile({this.userName, this.chatRoomId, this.imageUrl, this.otherName});

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 1),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationScreen(widget.chatRoomId),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * .13,
          decoration: BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey,
                backgroundImage: widget.imageUrl == null
                    ? null
                    : NetworkImage(widget.imageUrl),
              ),
              SizedBox(
                width: 12,
              ),
              Text(widget.userName.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
