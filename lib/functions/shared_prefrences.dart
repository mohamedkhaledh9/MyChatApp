import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesFunctions {
  static String sharedPrefrencesUserLoggedInKey = "IsLoggegIn";
  static String sharedPrefrencesUserNameKey = "UserNameKey";
  static String sharedPrefrencesUserEmailKey = "UserEmailKey";

  ///////////////set Values in Shared Pref
  static Future<bool> saveUserLoggedInSharedPrefrences(bool IsLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(sharedPrefrencesUserLoggedInKey, IsLoggedIn);
  }

  static Future<bool> saveUserNameSharedPrefrences(String UserName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPrefrencesUserNameKey, UserName);
  }

  static Future<bool> saveUserEmailSharedPrefrences(String UserEmail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPrefrencesUserEmailKey, UserEmail);
  }

  /////////// get values from shared
  static Future<bool> getUserLoggedInSharedPrefrences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getBool(sharedPrefrencesUserLoggedInKey);
  }

  static Future<String> getUserNameFromSharedPrefrences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(sharedPrefrencesUserNameKey);
  }

  static Future<String> getUserEmailFromSharedPrefrences() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.getString(sharedPrefrencesUserEmailKey);
  }
}
