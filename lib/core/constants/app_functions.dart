import 'package:intl/intl.dart';

class AppFunctions {
  static String getFormattedDate(DateTime dateTime) =>
      DateFormat('d MMM, yyyy').format(dateTime).toString();

  // country code
  static String getCountryCode(String country) {
    String code = "";

    switch (country) {
      case 'nepal':
        code = "+977";
        break;
      default:
        code = "";
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

//   capitalize words
  static String getCapitalizedWords(String sentence) {
    String finalString = "";

    List<String> words = sentence.toLowerCase().split(' ');

    for (var word in words) {
      finalString += "${word[0].toUpperCase()}${word.substring(1)} ";
    }

    return finalString;
  }
}
