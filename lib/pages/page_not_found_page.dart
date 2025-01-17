import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PageNotFoundPage extends StatelessWidget {
  const PageNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.hourglass_empty, color: Colors.deepPurple),
            Text(
              "Page Not Found!",
              style: TextStyle(color: Colors.grey.shade500),
            ),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text("Home"),
            ),
          ],
        ),
      ),
    );
  }
}
