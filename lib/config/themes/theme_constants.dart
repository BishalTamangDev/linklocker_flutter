import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,

    canvasColor: Colors.grey.shade200,

    // color scheme
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.blue,
      primary: Colors.blue,
      onPrimary: Colors.white,
      surface: Colors.grey.shade100,
      secondary: Colors.grey.shade300,
    ),

    // text theme
    textTheme: textTheme,

//   app bar theme
    appBarTheme: AppBarTheme(
      elevation: 1,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,

    canvasColor: Colors.black,

    // color scheme
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.blue,
      primary: Colors.blue,
      onPrimary: Colors.white,
      // surface: Colors.grey.shade900,
      surface: Colors.grey.shade900,
      secondary: Colors.black26,
    ),

    // text theme
    textTheme: textTheme,

    //   app bar theme
    appBarTheme: AppBarTheme(
      elevation: 1,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  );

  static TextTheme textTheme = TextTheme(
    // display
    displayLarge: TextStyle(fontFamily: 'Poppins'),
    displayMedium: TextStyle(fontFamily: 'Poppins'),
    displaySmall: TextStyle(fontFamily: 'Poppins'),

    // headline
    headlineLarge: TextStyle(fontFamily: 'Poppins'),
    headlineMedium: TextStyle(fontFamily: 'Poppins'),
    headlineSmall: TextStyle(fontFamily: 'Poppins'),

    // title
    titleLarge: TextStyle(fontFamily: 'Poppins'),
    titleMedium: TextStyle(fontFamily: 'Poppins'),
    titleSmall: TextStyle(fontFamily: 'Poppins'),

    // body
    bodyLarge: TextStyle(fontFamily: 'Poppins'),
    bodyMedium: TextStyle(fontFamily: 'Poppins'),
    bodySmall: TextStyle(fontFamily: 'Poppins'),

    // label
    labelLarge: TextStyle(fontFamily: 'Poppins'),
    labelSmall: TextStyle(fontFamily: 'Poppins'),
    labelMedium: TextStyle(fontFamily: 'Poppins'),
  );
}
