import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/services/database.dart';

class ConversationScreen extends StatefulWidget {
  static String id = "ConversationScreen";
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConersationScreenState createState() => _ConersationScreenState();
}

class _ConersationScreenState extends State<ConversationScreen> {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  TextEditingController messageController = TextEditingController();
  Stream messagesStream;

  messages() async {
    await _dataBaseMethods
        .showConversationMessages(widget.chatRoomId)
        .then((value) {
      setState(() {
        messagesStream = value;
      });
    });
  }

  sendMessage() {
    if (messageController.text != null) {
      Map<String, dynamic> messagesDetailsMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      _dataBaseMethods.addConversationMessages(
          widget.chatRoomId, messagesDetailsMap);
      messageController.text = "";
    }
  }

  Widget messagesList() {
    return StreamBuilder(
        stream: messagesStream,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return ListView.builder(
                reverse: true,
                shrinkWrap: true,
                itemCount: snapShot.data.docs.length,
                itemBuilder: (context, index) {
                  return messageTile(
                    snapShot.data.docs[index]["message"],
                    snapShot.data.docs[index]["sendBy"] == Constants.myName,
                  );
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

  Widget messageTile(String message, bool isSendByMe) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 20, right: isSendByMe ? 20 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isSendByMe
                    ? [Color(0xff7EF4), Color(0xff2A75BC)]
                    : [Color(0xFFBFEB91), Color(0xff7EF4)]),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))
                : BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
        child: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    messages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text(
              "${widget.chatRoomId.toString().replaceAll("_", "").replaceAll(Constants.myName, "").toUpperCase()}"),
          centerTitle: true,
        ),
        backgroundColor: Colors.white70,
        body: Container(
          child: Column(
            children: [
              Expanded(child: messagesList()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: kMainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.blue,
                            autofocus: true,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Type a message",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            controller: messageController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1),
                          child: IconButton(
                              iconSize: 30,
                              icon: Icon(Icons.send),
                              color: Colors.blue,
                              onPressed: () {
                                if (messageController.text != "") {
                                  sendMessage();
                                } else {
                                  return null;
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
