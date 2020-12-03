import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
import 'package:my_owen_chat_app/screens/conversation_screen.dart';
import 'package:my_owen_chat_app/services/database.dart';

class SearchPage extends StatefulWidget {
  static String id = "SearchPage";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchPage> {
  QuerySnapshot searchSnapShot;
  TextEditingController searchController = TextEditingController();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  creatChateRoomAndSendMessage(String userName) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroom_id": chatRoomId,
      };
      _dataBaseMethods.creatChatRom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ConversationScreen(chatRoomId);
      }));
    } else {
      print("Same Email !!!");
    }
  }

  search() {
    _dataBaseMethods.getUsersByUserName(searchController.text).then((value) {
      setState(() {
        searchSnapShot = value;
      });
    });
  }

  Widget searchTile({String userName, String userEmail}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey,
            border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(userName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                creatChateRoomAndSendMessage(userName);
              },
              child: Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: kMainColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(child: Text("Message")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searhResultList() {
    if (searchSnapShot != null) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: searchSnapShot.docs.length,
          itemBuilder: (context, index) {
            return searchTile(
              userName: searchSnapShot.docs[index].data()['name'],
              userEmail: searchSnapShot.docs[index].data()['email'],
            );
          });
    } else {
      return Container(
          child: Center(
        child: Text("No Matching Data !!"),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainColor,
        title: Text(
          "Search",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1)),
              height: MediaQuery.of(context).size.height * .1,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search By UserName ...",
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        fillColor: Colors.white30,
                        filled: true,
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.black,
                      iconSize: 30,
                      onPressed: () {
                        search();
                      })
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(child: Text("Search Result ...")),
            searhResultList(),
          ],
        ),
      ),
    );
  }
}
