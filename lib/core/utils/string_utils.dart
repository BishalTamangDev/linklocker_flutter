import 'package:linklocker/core/constants/county_codes.dart';

class StringUtils {
  // country code
  static String getCountryCode(String country) {
    String code = "+977";

    for (var countryCode in countryCodes) {
      if (countryCode['country'] == country) {
        code = countryCode['code'];
      }
    }

    return code;
  }

  // capitalize word
  static String getCapitalizedWord(String word) {
    String finalWord = "";

    word = word.toLowerCase();

    finalWord = word[0].toUpperCase() + word.substring(1);

    return finalWord;
  }

  // capitalize words
  static String getCapitalizedWords(String sentence) {
    String finalString = "";

    List<String> words = sentence.toLowerCase().split(' ');

    for (var word in words) {
      finalString += "${word[0].toUpperCase()}${word.substring(1)} ";
    }

    return finalString;
  }
}
