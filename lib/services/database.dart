import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  getUsersByUserName(String userName) async {
    return await firestore
        .collection("users")
        .where("name", isEqualTo: userName)
        .get();
  }

  getUsersByUserEmail(String userEmail) async {
    return await firestore
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    firestore.collection("users").add(userMap);
  }

  creatChatRom(String chatRoomId, chatRoomMap) {
    firestore.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap);
  }

  addConversationMessages(String chatRoomId, Map<String, dynamic> messageMap) {
    firestore
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap);
  }

  showConversationMessages(String chatRoomId) async {
    return await firestore
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getUsers(String userName) async {
    return await firestore
        .collection("ChatRoom")
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
