import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  // check for value :: if onboarding screen is already shown
  Future<void> _checkValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool initial = prefs.getBool('onboard_screen_shown') ?? false;

    if (!mounted) return;

    FlutterNativeSplash.remove();

    if (!initial) {
      context.pushReplacement('/onboarding');
    } else {
      context.pushReplacement('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
