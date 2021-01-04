import 'dart:ui';

import 'package:get/get.dart';
import 'package:my_owen_chat_app/locale_storage/save_language_value.dart';

class AppLanguages extends GetxController {
  var language ="en";
  @override
  void onInit() async {
    LocaleStorage _localeStorage = LocaleStorage();
    super.onInit();
    language = await _localeStorage.LanguageValue == null
        ? "en"
        : await _localeStorage.LanguageValue;
    Get.updateLocale(Locale(language));
    update();
  }

  void changeAppLanguage(String lang) async{
    LocaleStorage _localeStorage = LocaleStorage();
    if (language == lang) {
      return;
    }
    if (lang == "ar") {
      language = "ar";
      _localeStorage.saveLanguageValue("ar");
    }
    else {
      language = "en";
      _localeStorage.saveLanguageValue("en");
    }
    update();
  }
}
