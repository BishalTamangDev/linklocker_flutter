import 'package:flutter/material.dart';

class ProfileCardNotSetWidget extends StatelessWidget {
  const ProfileCardNotSetWidget({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 24.0,
          bottom: 6.0,
        ),
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(height: 12.0),
            Opacity(
              opacity: 0.6,
              child: const Text("You haven't set your profile yet!"),
            ),
            TextButton(
              onPressed: callback,
              child: const Text("Setup Now"),
            ),
          ],
        ),
      ),
    );
  }
}
