import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:my_owen_chat_app/getController/app_language_value.dart';
import 'package:my_owen_chat_app/providers/change_them_data.dart';
import 'package:my_owen_chat_app/screens/chat_rooms_screen.dart';
import 'package:my_owen_chat_app/screens/home_screen.dart';
import 'package:my_owen_chat_app/screens/search_screen.dart';
import 'package:my_owen_chat_app/screens/show_friends_status.dart';
import 'package:my_owen_chat_app/screens/show_my_status.dart';
import 'package:my_owen_chat_app/screens/sign_in_screen.dart';
import 'package:my_owen_chat_app/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'app_translations/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
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
  String lang ;
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

  getLanguageValue() async {
    await SharedPrefrencesFunctions.getLanguageValue().then((value) {
      setState(() {
        lang = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInValue();
    getModeValue();
    getLanguageValue();
  }

  @override
  Widget build(BuildContext context) {
    AppLanguages _appLanguages=Get.put(AppLanguages());
    print("app Language is ${_appLanguages.language}");
    return GetMaterialApp(
      translations: Translation(),
      locale: Locale("en"),
      fallbackLocale: Locale("en"),
      theme: modeValue == "LightMode" ? ThemeData.light() : ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen() : SignIn(),
      routes: {
        SignUp.id: (context) => SignUp(),
        ChatRoom.id: (context) => ChatRoom(),
        SearchPage.id: (context) => SearchPage(),
        SignIn.id: (context) => SignIn(),
        ShowMyStatus.id:(context)=>ShowMyStatus(),
        ShowFriendsStatus.id:(context)=>ShowFriendsStatus(),

      },
    );
  }
}
