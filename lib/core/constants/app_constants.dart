import 'package:flutter/material.dart';

class AppConstants {
  static final appName = "LinkLocker";

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

  static List<Map<String, Color>> categoryColor = [
    {'family': Colors.purple},
    {'friend': Colors.red},
    {'relative': Colors.orange},
    {'coworker': Colors.blue},
    {'teacher': Colors.deepPurple},
    {'other': Colors.grey},
  ];
}
