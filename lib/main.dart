import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
import 'package:my_owen_chat_app/screens/conversation_screen.dart';
import 'package:my_owen_chat_app/screens/search_screen.dart';
import 'package:my_owen_chat_app/screens/sign_in_screen.dart';
import 'package:my_owen_chat_app/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  getLoggedInValue() async {
    await SharedPrefrencesFunctions.getUserLoggedInSharedPrefrences()
        .then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInValue();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? ChatRoom() : SignIn(),
      routes: {
        SignUp.id: (context) => SignUp(),
        ChatRoom.id: (context) => ChatRoom(),
        SearchPage.id: (context) => SearchPage(),
        SignIn.id: (context) => SignIn(),
      },
    );
  }
}
