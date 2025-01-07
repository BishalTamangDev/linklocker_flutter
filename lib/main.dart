import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linklocker/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // screen orientation
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  runApp(const LinkLocker());
}
