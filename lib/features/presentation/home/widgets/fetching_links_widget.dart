import 'package:flutter/material.dart';

class FetchingLinksWidget extends StatelessWidget {
  const FetchingLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16.0,
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          CircularProgressIndicator(),
          Opacity(
            opacity: 0.6,
            child: Text("Fetching links"),
          ),
        ],
      ),
    );
    ;
  }
}
