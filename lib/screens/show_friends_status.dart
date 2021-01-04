import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_owen_chat_app/constans.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/services/database.dart';
import 'package:get/get.dart';

class ShowFriendsStatus extends StatefulWidget {
  static String id = "ShowFriendsStatus";

  @override
  _ShowFriendsStatusState createState() => _ShowFriendsStatusState();
}

class _ShowFriendsStatusState extends State<ShowFriendsStatus> {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  Stream statusStream;

  status() async {
    await _dataBaseMethods.getStatus(Constants.myName).then((status) {
      setState(() {
        statusStream = status;
      });
    });
  }

  @override
  void initState() {
    status();
  }

  @override
  Widget build(BuildContext context) {
    String stateSender = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(stateSender + "  Status"),
        backgroundColor: kMainColor,
      ),
      body: StreamBuilder(
          stream: statusStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data.docs[index]["name"] == stateSender) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  child: Image(
                                    width: Get.width,
                                    height: Get.height,
                                    image: snapshot.data.docs[index]["state"] ==
                                            null
                                        ? null
                                        : NetworkImage(
                                            snapshot.data.docs[index]["state"]),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: kMainColor,
                                      radius: 35,

                                      backgroundImage: snapshot.data.docs[index]
                                                  ["image_url"] ==
                                              null
                                          ? null
                                          : NetworkImage(
                                              snapshot.data.docs[index]["image_url"]),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            stateSender.toUpperCase(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,color: Colors.white),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            snapshot.data.docs[index]["state_time"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Text("");
                    }
                  });
            } else {
              return Center(
                child: Text("No Status ..."),

              );
            }
          }),
    );
  }
}
