import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_language/custom_language.dart';
import 'package:custom_language/language_instance.dart';

class LanguageConcrete extends CustomLanguage {
  @override
  String get langCode;

  @override
  Map<String, LanguageInstance> get addedLanguages;
  
  LanguageConcrete({
    @required langCode,
    @required addedLanguages
  }) : super(langCode: langCode, addedLanguages: addedLanguages);
}
