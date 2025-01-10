import 'package:flutter/material.dart';

class SearchErrorWidget extends StatelessWidget {
  const SearchErrorWidget({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          spacing: 12.0,
          children: const <Widget>[
            Icon(
              Icons.error_outline_outlined,
              color: Colors.red,
            ),
            Text("An error occurred!"),
          ],
        ),
      );
}
