import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_owen_chat_app/constants/constants.dart';
import 'package:my_owen_chat_app/functions/shared_prefrences.dart';
import 'package:get/get.dart';
import 'package:my_owen_chat_app/getController/app_language_value.dart';
import 'package:my_owen_chat_app/screens/sign_in_screen.dart';
import 'package:my_owen_chat_app/services/auth.dart';
import 'package:my_owen_chat_app/widgets/divider.dart';

class AppDrawer extends StatefulWidget {
  final String userEmail;
  final String userImageUrl;

  const AppDrawer({this.userEmail, this.userImageUrl});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: widget.userImageUrl != null
                          ? NetworkImage(widget.userImageUrl)
                          : null,
                    ),
                    title: Text(
                      Constants.myName != null
                          ? Constants.myName.toUpperCase()
                          : "",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                    child:
                        Text(widget.userEmail == null ? "" : widget.userEmail),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            ExpansionTile(
              title: ListTile(
                title: Text("Profile Settings".tr),
                leading: Icon(Icons.settings),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ExpansionTile(
                    title: ListTile(
                      title: Text("Themes".tr),
                      leading: Icon(Icons.theaters),
                    ),
                    children: [
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            Get.changeTheme(ThemeData.light());
                            SharedPrefrencesFunctions
                                .saveUserModeSharedPrefrences("LightMode".tr);
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Light Mode".tr),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            Get.changeTheme(ThemeData.dark());
                            SharedPrefrencesFunctions
                                .saveUserModeSharedPrefrences("DarkMode".tr);
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Dark Mode".tr),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ExpansionTile(
                    title: ListTile(
                      title: Text("App Languages".tr),
                      leading: Icon(Icons.language),
                    ),
                    children: [
                      GetBuilder<AppLanguages>(
                          init: AppLanguages(),
                          builder: (controller) {
                            return FlatButton(
                              onPressed: ()async {
                                controller.changeAppLanguage("en");
                                Get.updateLocale(Locale(controller.language));
                                Navigator.pop(context);
                              },
                              child: Text("English".tr),
                            );
                          }),
                      GetBuilder<AppLanguages>(
                          init: AppLanguages(),
                          builder: (controller) {
                            return FlatButton(
                              onPressed: ()async {
                                controller.changeAppLanguage("ar");
                                Get.updateLocale(Locale(controller.language));
                                Navigator.pop(context);
                              },
                              child: Text("Arabic".tr),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: ListTile(
                onTap: () async {
                  await _authMethods.signOut();
                  await SharedPrefrencesFunctions
                      .saveUserLoggedInSharedPrefrences(false);
                  Get.offAll(SignIn());
                },
                title: Text(
                  "Log Out".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Icon(Icons.exit_to_app),
              ),
            ),
            CustomDivider(),
          ],
        ),
      ),
    );
    // return MultiLevelDrawer(
    //   backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
    //   subMenuBackgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
    //   header: Column(
    //     children: [
    //       SizedBox(
    //         height: 35,
    //       ),
    //       ListTile(
    //         leading: CircleAvatar(
    //           radius: 22,
    //           backgroundColor: Colors.grey,
    //           backgroundImage: widget.userImageUrl != null
    //               ? NetworkImage(widget.userImageUrl)
    //               : null,
    //         ),
    //         title: Text(
    //           Constants.myName != null ? Constants.myName.toUpperCase() : "",
    //           style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //         child: Text(widget.userEmail == null ? "" : widget.userEmail),
    //       ),
    //       SizedBox(height: 15,),
    //       CustomDivider(),
    //     ],
    //   ),
    //   children: [
    //     MLMenuItem(
    //       onClick: () {},
    //       content: Text("Profile Settings".tr),
    //       leading: Icon(Icons.settings),
    //     ),
    //     MLMenuItem(
    //       content: Text("Themes".tr),
    //       onClick: () {},
    //       leading: Icon(Icons.theaters),
    //       trailing: Icon(Icons.arrow_right),
    //       subMenuItems: [
    //         MLSubmenu(
    //           submenuContent: Text("Light Mode".tr),
    //           onClick: () {
    //             setState(() {
    //               Get.changeTheme(ThemeData.light());
    //               SharedPrefrencesFunctions.saveUserModeSharedPrefrences(
    //                   "LightMode");
    //               Navigator.pop(context);
    //             });
    //           },
    //         ),
    //         MLSubmenu(
    //           submenuContent: Text("Dark Mode".tr),
    //           onClick: () {
    //             setState(() {
    //               Get.changeTheme(ThemeData.dark());
    //               SharedPrefrencesFunctions.saveUserModeSharedPrefrences(
    //                   "DarkMode".tr);
    //               Navigator.pop(context);
    //             });
    //           },
    //         ),
    //       ],
    //     ),
    //     MLMenuItem(
    //       content: Text("Languages".tr),
    //       onClick: () {},
    //       leading: Icon(Icons.language),
    //       trailing: Icon(Icons.arrow_right),
    //       subMenuItems: [
    //         MLSubmenu(
    //           submenuContent: Text("English".tr),
    //           onClick: () async {
    //             Get.updateLocale(
    //               Locale("en"),
    //             );
    //            // await SharedPrefrencesFunctions.saveAppLanguage("en");
    //             appLanguages.changeAppLanguage("en");
    //             Navigator.pop(context);
    //           },
    //         ),
    //         MLSubmenu(
    //           submenuContent: Text("Arabic".tr),
    //           onClick: () async {
    //             Get.updateLocale(
    //               Locale("ar"),
    //             );
    //             //await SharedPrefrencesFunctions.saveAppLanguage("ar");
    //             appLanguages.changeAppLanguage("ar");
    //             Navigator.pop(context);
    //           },
    //         ),
    //       ],
    //     ),
    //     MLMenuItem(
    //       content: Text("Log Out".tr),
    //       onClick: () async {
    //         await _authMethods.signOut();
    //         await SharedPrefrencesFunctions.saveUserLoggedInSharedPrefrences(
    //             false);
    //         Get.offAll(SignIn());
    //       },
    //       leading: Icon(Icons.exit_to_app),
    //     ),
    //   ],
    // );
  }
}
