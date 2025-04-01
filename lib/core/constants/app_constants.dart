import 'package:flutter/material.dart';

enum LinkCategoryEnum {
  businessPartner,
  client,
  coworker,
  doctor,
  emergency,
  family,
  friend,
  investor,
  lawyer,
  relative,
  serviceProvider,
  student,
  teacher,
  other;

  static LinkCategoryEnum? getCategoryFromLabel(String label) {
    return LinkCategoryEnum.values.firstWhere(
      (e) => e.label == label,
      orElse: () => LinkCategoryEnum.other,
    );
  }

  String get label {
    switch (this) {
      case LinkCategoryEnum.businessPartner:
        return "Business Partner";
      case LinkCategoryEnum.client:
        return "Client";
      case LinkCategoryEnum.coworker:
        return "Coworker";
      case LinkCategoryEnum.doctor:
        return "Doctor";
      case LinkCategoryEnum.emergency:
        return "Emergency";
      case LinkCategoryEnum.family:
        return "Family";
      case LinkCategoryEnum.friend:
        return "Friend";
      case LinkCategoryEnum.investor:
        return "Investor";
      case LinkCategoryEnum.lawyer:
        return "Lawyer";
      case LinkCategoryEnum.relative:
        return "Relative";
      case LinkCategoryEnum.serviceProvider:
        return "Service Provider";
      case LinkCategoryEnum.student:
        return "Student";
      case LinkCategoryEnum.teacher:
        return "Teacher";
      case LinkCategoryEnum.other:
        return "Other";
    }
  }

  Color get color {
    switch (this) {
      case LinkCategoryEnum.businessPartner:
        return Colors.pink;
      case LinkCategoryEnum.client:
        return Colors.indigo;
      case LinkCategoryEnum.coworker:
        return Colors.purple;
      case LinkCategoryEnum.doctor:
        return Colors.cyan;
      case LinkCategoryEnum.emergency:
        return Colors.red;
      case LinkCategoryEnum.family:
        return Colors.orange;
      case LinkCategoryEnum.friend:
        return Colors.blue;
      case LinkCategoryEnum.investor:
        return Colors.lime;
      case LinkCategoryEnum.lawyer:
        return Colors.deepPurple;
      case LinkCategoryEnum.relative:
        return Colors.green;
      case LinkCategoryEnum.serviceProvider:
        return Colors.amber;
      case LinkCategoryEnum.student:
        return Colors.teal;
      case LinkCategoryEnum.teacher:
        return Colors.brown;
      case LinkCategoryEnum.other:
        return Colors.grey;
    }
  }
}

class AppConstants {
  // application name
  static final String appName = "LinkLocker";

  // default user image
  static final String defaultUserImage = "assets/images/blank_user.png";

  static final String defaultCountry = "nepal";

 // colors
  static Color primaryColor = Colors.blue;
  static Color callIconColor = Colors.green;
  static Color emailIconColor = Colors.deepOrange;
  static Color birthdayIconColor = Colors.lightBlue;
  static Color categoryIconColor = Colors.deepPurple;
  static Color noteIconColor = Colors.grey;

  // country codes
  static List<Map<String, dynamic>> countryCodes = [
    {
      'country': 'australia',
      'code': '+61',
    },
    {
      'country': 'india',
      'code': '+91',
    },
    {
      'country': 'nepal',
      'code': '+977',
    },
    {
      'country': 'us',
      'code': '+1',
    },
  ];
}
