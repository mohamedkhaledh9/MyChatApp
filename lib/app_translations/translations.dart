import 'package:get/get_navigation/src/root/internacionalization.dart';
import 'package:my_owen_chat_app/app_languages/ar.dart';
import 'package:my_owen_chat_app/app_languages/en.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys =>
      {
        "en": en,
        "ar":ar,
      };
}