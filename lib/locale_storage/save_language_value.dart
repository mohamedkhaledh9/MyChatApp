import 'package:get_storage/get_storage.dart';

class LocaleStorage {
  void  saveLanguageValue(String languageValue) async {
    await GetStorage().write("language", languageValue);
  }
  Future<String> get LanguageValue async{
    return await GetStorage().read("language");

  }
}
