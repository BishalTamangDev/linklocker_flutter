import 'package:flutter/material.dart';

class MiniProfileWidgetLoading extends StatelessWidget {
  const MiniProfileWidgetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 32.0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      title: Opacity(
        opacity: 0.6,
        child: Text("Loading your details..."),
      ),
      subtitle: Text("My Profile"),
    );
  }
}
