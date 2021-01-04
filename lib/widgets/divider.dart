import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  Color co;
  CustomDivider({this.co});
  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: 3,
     // color: Get.isDarkMode ? Colors.white : Colors.black,
      height: 5,
      thickness: 3,
      endIndent: 3,
    );
  }
}
