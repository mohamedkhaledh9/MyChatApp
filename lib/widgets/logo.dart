import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image(
              image: AssetImage('images/logo.jpg'),
            ),
            // Positioned(
            //   bottom: 0,
            //   child: Text(
            //     "MyChat",
            //     style: TextStyle(
            //         fontSize: 25,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
