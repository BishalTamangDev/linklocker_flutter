import 'package:flutter/material.dart';

class SearchingWidget extends StatelessWidget {
  const SearchingWidget({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          spacing: 16.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Text("Searching.."),
          ],
        ),
      );
}
