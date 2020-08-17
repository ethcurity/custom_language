import 'package:custom_language/lang_model.dart';
import 'package:custom_language/language_instance.dart';

class LangEnglish extends LanguageInstance {
  String get replaceString => super.replaceString;
  String get langCode => 'en';
  String get langName => 'English';
  String get langValue => 'Language';
  
  @override
  List<LangModel> get langValues => super.langValues;

  init() {
    langValues = [
      LangModel('hello', 'Hello $replaceString'),
      LangModel('itemsAdded', 'You have added $replaceString item(s)'),
      LangModel('congra', 'Congratulations'),
      LangModel('orderChange', '$replaceString and $replaceString')
    ];
  }
}