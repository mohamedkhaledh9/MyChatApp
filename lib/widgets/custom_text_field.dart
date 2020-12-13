import 'package:flutter/material.dart';
import 'package:my_owen_chat_app/constans.dart';

class CustomFormField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final IconButton icon2;
  final Function onClic;
  final bool showPass;
  CustomFormField(
      {@required this.onClic,
      @required this.icon,
      @required this.hint,
      this.showPass,
      this.icon2});
  String _messageError() {
    switch (hint) {
      case "Enter your full name ":
        return " Empty Name !!! ";
        break;
      case "Enter Your Email":
        return " Empty Email !! ";
        break;
      case "Enter Your Password":
        return " Empty Password !! ";
      case "Enter User Name":
        return "Plz,Enter Your User Name";
      case "Enter password":
        return "Empty password !!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        onSaved: onClic,
        obscureText:
            (hint == "Enter Your Password" && showPass == false) ? true : false,
        validator: (value) {
          if (value.isEmpty) {
            return _messageError();
          }
        },
        cursorColor: kMainColor,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(
            icon,
            color: kMainColor,
          ),
          // suffixIcon: Icon(
          //   icon2,
          //   color: kMainColor,
          // ),
          suffixIcon: icon2,
          hintText: hint,
          filled: true,
          fillColor: Colors.white70,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
