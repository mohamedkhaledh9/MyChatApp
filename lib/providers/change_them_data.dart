import 'package:flutter/material.dart';

class ChangeThemData extends ChangeNotifier {
  ThemeData themeData;

  ChangeThemData(this.themeData);

  setThem(ThemeData _themData) {
    themeData = _themData;
    notifyListeners();
  }

  getThem() {
    return themeData;
  }
}
