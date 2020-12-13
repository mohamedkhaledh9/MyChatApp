import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/providers/change_them_data.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
import 'package:my_owen_chat_app/screens/search_screen.dart';
import 'package:my_owen_chat_app/screens/sign_in_screen.dart';
import 'package:my_owen_chat_app/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChangeThemData>(
            create: (context) => ChangeThemData(ThemeData.light())),
      ],
      child: MaterialThemData(),
    );
  }
}

class MaterialThemData extends StatefulWidget {
  @override
  _MaterialThemDataState createState() => _MaterialThemDataState();
}

class _MaterialThemDataState extends State<MaterialThemData> {
  bool isLoggedIn = false;
  String modeValue = "LightMode";

  getModeValue() async {
    await SharedPrefrencesFunctions.getUserModeFromSharedPrefrences()
        .then((value) {
      setState(() {
        modeValue = value;
      });
    });
  }

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
    getModeValue();
  }

  @override
  Widget build(BuildContext context) {
    ChangeThemData changeThemData = Provider.of(context);
    return GetMaterialApp(
        theme: modeValue == "LightMode" ? ThemeData.light() : ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? ChatRoom() : SignIn(),
        routes: {
          SignUp.id: (context) => SignUp(),
          ChatRoom.id: (context) => ChatRoom(),
          SearchPage.id: (context) => SearchPage(),
          SignIn.id: (context) => SignIn(),
        });
  }
}
