<h1 align="center">Flutter Custom Language</h1>
# custom_language

A Flutter package to add multiple language support for your application.

## Table of Contents
  - [Installing](#installing) - How to install
  - [Import](#import) - Import the package
  - [Example Languages Instances](#example-language-instances) - Create Language Models
    - [English Language Instance](#english-language-instance)
    - [Amharic Language Instance](#amharic-language-instance)
  - [Create Language Model](#create-language-model)
  - [Complete Example](#complete-example)

## Installing
Add to pubspec.yaml file

```sh
dependencies:
  custom_language: ^1.0.1
```
# Import

```sh
import 'package:custom_language/custom_language.dart';
```

## Example Language Instances
in the below code i will create a class for English and Amharic language
you can create unlimited number of language instances

## English Language Instances

```dart
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
```
## Amharic Language Instance

```dart
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
```
## Create Language Model
```dart
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
```

## Complete Example
```dart
	// initiate 
    CustomLanguage langModel = LanguageModel(langCode: 'en')..setCurrentLanguage();

    // Value with appendable values added
    print(langModel.get('hello', append: ['Ethcurity']));

    // Value without appendable values added
    print(langModel.get('congra'));

    CustomLanguage otherLangModel = langModel.withCode(langCode: 'am');
    print(otherLangModel.get('hello', append: ['Ethcurity']));

    var product = json.decode('{"product": {"name_english": "Computer", "name_amharic": "ኮምፒተር"}}');
    print(product['product']['name_english']);

    /// `name_e` and `name_a` has been added in `LanguageModel` class and make sure to do that before passing values
    List<String> productName = langModel.parse(product['product'], keys: ['name_e', 'name_a']);
    print(langModel.set(productName));
    print(otherLangModel.set(productName));

    print(langModel.join(':', values: productName));

    /// the below example demonstrates how you can use order changes among you language dependencies
    print(langModel.get('orderChange', append: [10, 20]));
    print(otherLangModel.get('orderChange', append: [10, 20]));
```
