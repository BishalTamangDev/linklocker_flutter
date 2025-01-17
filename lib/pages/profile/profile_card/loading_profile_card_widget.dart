import 'package:flutter/material.dart';

class LoadingProfileCardWidget extends StatelessWidget {
  const LoadingProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(),
        ListTile(
          leading: CircleAvatar(
            radius: 32.0,
            backgroundColor: Theme.of(context).canvasColor,
          ),
          title: Opacity(
            opacity: 0.6,
            child: Text("Loading your details..."),
          ),
          subtitle: Text("My Profile"),
        ),
        const SizedBox(),
      ],
    );
  }
}
