library custom_language;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:custom_language/dropdown_language_model.dart';
import 'package:custom_language/lang_model.dart';
import 'package:custom_language/language_concrete.dart';
import 'package:custom_language/language_instance.dart';

///```dart
///class LanguageModel extends CustomLanguage {
///  @override
///  Map<String, LanguageInstance> get addedLanguages => {
///    'am': LangAmharic(),
///    'en': LangEnglish()
///  };
///  
///  @override
///  List<LangModel> get globalAccessableValues => [
///    LangModel('name_e', 'name_english'),
///    LangModel('name_a', 'name_amharic')
///  ];
///  
///  LanguageModel({
///    @required String langCode
///  }) : super(langCode: langCode);
///}
///```
abstract class CustomLanguage {
  /// the `language id` given to the selected language instance
  int selectedLangId = 0;

  /// the `language code` like `en` of the currently selected language
  String langCode;

  /// language representation of the current language
  List<LangModel> langValues;

  /// `replaceString` is a String that will be used when we want to append additional data to the current
  /// data for example if we have a `langValue` with code `price` and value `Price:`
  String replaceString = '{{|}}';

  /// this is the variable that holds the added languages 
  Map<String, LanguageInstance> addedLanguages = new Map<String, LanguageInstance>();

  /// this variable holds values that are shared between all the language models
  /// this helps us not to decleare multiple same values from multiple class
  List<LangModel> globalAccessableValues = new List<LangModel>();

  /// holds info about the current selected language
  LanguageInstance languageInstance;
  
  /// currently available languages index
  Map<String, int> languagesIndex = new Map<String, int>();

  CustomLanguage({
    @required this.langCode,
    this.addedLanguages
  });

  /// this function returns the associated value of the langKey that means the first parameter of `LangModel`
  /// and if there is any value that the language model accepts it appends respectively
  /// for example if we assume that `itemsAdded` holds the below value
  /// for English `You have added $replaceString item(s)`
  /// for Amharic `$replaceString እቃ(ዎችን) አክለዋል`
  /// 
  /// ```dart
  /// String currencyValue = langModel.get('itemsAdded', append: ['10']);
  /// ```
  /// if the currently selected language is `English` the value for `currencyValue` will be `You have added 10 item(s)`
  /// if the currently selected language is `Amharic` the value for `currencyValue` will be `10 እቃ(ዎችን) አክለዋል`
  String get(String langKey, {String alt = '', List<dynamic> append = const []}) {
    try {
      String retValue = langValues.firstWhere((i) => i.key == "$langKey").value.toString();
      append.forEach((appendable) {
        retValue = retValue.replaceFirst('$replaceString', appendable.toString());
      });
      return retValue.toString();
    } catch(_) {
      return alt.toString();
    }
  }
  
  /// returns all the available languages as a dropdown model
  List<DropdownLangModel> getAvailableLanguages() {
    List<DropdownLangModel> droprownLangModel = new List<DropdownLangModel>(); 
    addedLanguages.entries.forEach((addedLanguage) {
      droprownLangModel.add(DropdownLangModel(
        id: languagesIndex.length,
        langName: addedLanguage.value.langName,
        langCode: addedLanguage.value.langCode,
        langValue: addedLanguage.value.langValue
      ));
      languagesIndex.addAll({'${addedLanguage.value.langCode}': languagesIndex.length});
    });

    return droprownLangModel;
  }

  /// this function set the current language values from its respective class
  /// or refresh if there is any changes made
  /// and adds the `globalAccessableValues` to the model
  setCurrentLanguage() {
    Map<String, int> languagesIndex = new Map<String, int>();
    addedLanguages.entries.forEach((addedLanguage) {
      languagesIndex.addAll({'${addedLanguage.value.langCode}': languagesIndex.length});
    });

    languageInstance = addedLanguages.entries.firstWhere(
      (addedLanguage) => addedLanguage.key.toString().toLowerCase() == langCode.toString().toLowerCase()
    ).value;

    languageInstance.replaceString = replaceString;
    languageInstance..init();

    langCode = languageInstance.langCode.toString().toLowerCase();
    langValues = languageInstance.getLangValues();
    selectedLangId = languagesIndex.entries.firstWhere((element) => element.key.toString().toLowerCase() == langCode.toString().toLowerCase()).value;
    langValues.addAll(globalAccessableValues);
  }

  /// this function will be used to call other language models directly from the currently selected language model
  /// for example if the current selected language is `English` and i wanted to access others language values without changing
  /// the currently selected language like `Amharic` i can do it like this with language code `am`
  /// ```dart
  /// otherLangModel = langModel.withCode(langCode: 'am');
  /// ```
  /// so now we now have an other language besides from the selected language 
  CustomLanguage withCode({@required String langCode}) {  
    CustomLanguage langModel = LanguageConcrete(
      langCode: langCode, 
      addedLanguages: addedLanguages
    );
    langModel.setCurrentLanguage();

    langModel.langValues.addAll(langModel.globalAccessableValues);
    return langModel;
  }

  /// this function parses values from a `JSON` Object with multible language dependences
  /// for example if we have a values the come from an Api call or something like this
  /// ```
  /// {
  ///   'product': {
  ///     'name_english': 'Computer',
  ///     'name_amharic': 'ኮምፒተር'
  ///   }
  /// }
  /// ```
  /// we can call the parse method and it returns an array based on the order of the keys passed
  /// 
  /// before we do this we need to add `name_e` and `name_a` in the `globalAccessableValues`
  /// ```dart
  /// var product = json.decode("{
  ///   'product': {
  ///     'name_english': 'Computer',
  ///     'name_amharic': 'ኮምፒተር'
  ///   }
  /// }");
  /// 
  /// List<String> productName = langModel.parse(product, keys: ['name_e', 'name_a']);
  /// ```
  /// if we have a value we want to append to every value we can pass it like this
  /// ```dart
  /// List<String> productName = langModel.parse(product, keys: ['name_e', 'name_a'], append: ' - Intel i5');
  /// ```
  List<String> parse(dynamic value, {List<String> keys = const [], String append = ""}) {
    List<String> retString = [];
    keys.forEach((key) {
      try {
        if(value[get(key)] != null) {retString.add(value[get(key)] + append);}
        else {retString.add(append);}
      } catch(_) {retString.add(append);}
    });

    return retString;
  }
  
  /// this function gets a value from the an array and returns a String based on the selected language
  /// if the length of the array passed is less than the available languages it return the first value of the array
  /// assume if we have a product with two different name like below
  /// ```dart
  /// // this code check if the current language id is in range of `productName` length assign value based on the language id 
  /// 
  /// List<String> productName = ['Computer', 'ኮምፒተር'];
  /// String curProductName = langModel.set(productName);
  /// ```
  String set(List<dynamic> value, {int index = -1}) {
    List<dynamic> retValue = value;
    if(index == -1) {index = selectedLangId;}
    try {
      if(retValue.length <= index && retValue.elementAt(index) == null) {
        return retValue.elementAt(0).toString();
      }

      return retValue.elementAt(index).toString();
    } catch(_) {
      return value.elementAt(0);
    }
  }

  /// this function joins an array with a string
  String join(String joiner, {List<dynamic> values}) {
    return values.join(joiner);
  }
}