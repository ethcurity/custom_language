import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:custom_language/custom_language.dart';
import 'lang/language_test.dart';

void main() {
  test('adds one to input values', () {
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

    
  });
}
