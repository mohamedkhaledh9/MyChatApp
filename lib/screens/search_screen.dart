import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/screens/conversation_screen.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  // final String ImageUrl;
  // SearchPage(this.ImageUrl);
  static String id = "SearchPage";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchPage> {
  QuerySnapshot searchSnapShot;
  QuerySnapshot userImage;
  TextEditingController searchController = TextEditingController();
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  String imageUrl;

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  creatChateRoomAndSendMessage(String userName) async {
    if (userName != Constants.myName) {
      await _dataBaseMethods.getUsersByUserName(userName).then((value) {
        setState(() {
          userImage = value;
        });
      });
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroom_id": chatRoomId,
        "myUserName": Constants.myName,
        "otherUserName": userName,
        "otherUserImageUrl": userImage.docs[0].data()["image_url"],
        "myImageUrl":imageUrl,
      };
      _dataBaseMethods.creatChatRom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ConversationScreen(chatRoomId);
      }));
    } else {
      Get.snackbar("Error !!!".tr, "You Can't Send Message To Your Self !!!".tr,
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red,maxWidth: 500,);
    }
  }

  getUserImage() async {
    await SharedPrefrencesFunctions.getUserImageUrlFromSharedPrefrences().then((value){
      setState(() {
        imageUrl=value;
      });
    });
    await SharedPrefrencesFunctions.getUserEmailFromSharedPrefrences();
    await _dataBaseMethods.getUsersimages(Constants.myName).then((value) {
      setState(() {
        userImage = value;
      });
    });
  }

  search() {
    _dataBaseMethods
        .getUsersByUserName(searchController.text.trim())
        .then((value) {
      setState(() {
        searchSnapShot = value;
      });
    });
  }

  Widget searchTile({String userName, String userEmail, String userImageUrl}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueGrey,
            border: Border.all(color: Colors.white)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(userImageUrl),
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
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(child: Text("Send Message".tr)),
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
            if (searchSnapShot.docs.length != null) {
              try {
                return searchTile(
                  userName: searchSnapShot.docs[index].data()['name'],
                  userEmail: searchSnapShot.docs[index].data()['email'],
                  userImageUrl: searchSnapShot.docs[index].data()['image_url'],
                );
              } catch (e) {
                print(e);
              }
            } else {
              return Center(
                child: Text("Searching.....".tr),
              );
            }
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
    // getimageUrl();
    getUserImage();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainColor,
        title: Text(
          "Search Page".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
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
                          hintText: "Search By UserName".tr,
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
                        }),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text("Search Result ...".tr),
              ),
              searhResultList(),
            ],
          ),
        ),
      ),
    );
  }
}
