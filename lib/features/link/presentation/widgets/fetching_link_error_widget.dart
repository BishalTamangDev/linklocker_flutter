import 'package:flutter/material.dart';

class FetchingLinkErrorWidget extends StatelessWidget {
  const FetchingLinkErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16.0,
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Icon(
            Icons.error_outline_outlined,
            color: Colors.red,
          ),
          Opacity(
            opacity: 0.6,
            child: Text("Fetching links"),
          ),
        ],
      ),
    );
  }
}
