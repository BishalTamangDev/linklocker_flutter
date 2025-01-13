import 'package:flutter/material.dart';

class ProfileCardErrorWidget extends StatelessWidget {
  const ProfileCardErrorWidget({super.key, required this.callback});

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
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            const SizedBox(height: 12.0),
            const Text("An error occurred!"),
            TextButton(
              onPressed: callback,
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }
}
