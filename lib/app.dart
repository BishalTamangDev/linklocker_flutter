import 'package:flutter/material.dart';
import 'package:linklocker/config/routes/routes.dart';
import 'package:linklocker/config/themes/theme_constants.dart';

class LinkLocker extends StatelessWidget {
  const LinkLocker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoute.routes,
      title: "LinkLocker",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
