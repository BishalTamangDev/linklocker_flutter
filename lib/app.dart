import 'package:flutter/material.dart';
import 'package:linklocker/config/themes/theme_constants.dart';
import 'package:linklocker/features/presentation/home/home_page.dart';

class LinkLocker extends StatelessWidget {
  const LinkLocker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LinkLocker",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: HomePage(),
    );
  }
}
