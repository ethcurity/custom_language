import 'package:custom_language/lang_model.dart';
import 'package:flutter/material.dart';
import 'package:custom_language/custom_language.dart';
import 'package:custom_language/language_instance.dart';

import 'lang_am.dart';
import 'lang_en.dart';

class LanguageModel extends CustomLanguage {
  /// make sure to change `replaceString` to other string that you will not use in your app
  /// the default value is `{{|}}`
  @override
  String get replaceString => super.replaceString;

  /// holds information about the current selected language
  @override
  LanguageInstance get languageInstance => super.languageInstance;
  
  @override
  Map<String, LanguageInstance> get addedLanguages => {
    'en': LangEnglish(),
    'am': LangAmharic(),
  };
  
  @override
  List<LangModel> get globalAccessableValues => [
    LangModel('name_e', 'name_english'),
    LangModel('name_a', 'name_amharic')
  ];
  
  LanguageModel({
    @required String langCode
  }) : super(langCode: langCode);
}