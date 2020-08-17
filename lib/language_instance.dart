import 'package:custom_language/lang_model.dart';

abstract class LanguageInstance {
  String replaceString = '{{|}}';
  String langCode;
  String langName;
  String langValue;
  List<LangModel> langValues = new List<LangModel>();

  getLangValues() {
    return langValues;
  }

  init();
}