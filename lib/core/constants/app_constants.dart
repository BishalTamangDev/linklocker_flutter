import 'package:flutter/material.dart';

class AppConstants {
  // application name
  static final String appName = "LinkLocker";

  // default user image
  static final String defaultUserImage = "assets/images/blank_user.png";

  static final String defaultCountry = "nepal";

//   colors
  static Color primaryColor = Colors.blue;
  static Color callIconColor = Colors.green;
  static Color emailIconColor = Colors.deepOrange;
  static Color birthdayIconColor = Colors.lightBlue;
  static Color categoryIconColor = Colors.deepPurple;
  static Color noteIconColor = Colors.grey;

//   categories
  static List<String> categoryList = [
    'family',
    'friend',
    'relative',
    'coworker',
    'teacher',
    'other',
  ];

  // category-wise color
  static List<Map<String, Color>> categoryColor = [
    {'family': Colors.green},
    {'friend': Colors.red},
    {'relative': Colors.orange},
    {'coworker': Colors.blue},
    {'teacher': Colors.deepPurple},
    {'other': Colors.grey},
  ];

//   country codes
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
