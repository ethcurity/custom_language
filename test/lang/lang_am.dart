import 'package:custom_language/lang_model.dart';
import 'package:custom_language/language_instance.dart';

class LangAmharic extends LanguageInstance {
  String get replaceString => super.replaceString;
  String get langCode => 'am';
  String get langName => 'Amharic';
  String get langValue => 'ቋንቋ';

  @override
  List<LangModel> get langValues => super.langValues;

  init() {
    langValues = [
      LangModel('hello', 'ሰላም $replaceString'),
      LangModel('itemsAdded', '$replaceString እቃ(ዎችን) አክለዋል'),
      LangModel('congra', 'እንኳን ደስ አለዎት'),
      LangModel('orderChange', '$replaceString እና $replaceString', order: [1, 0])
    ];
  }
}