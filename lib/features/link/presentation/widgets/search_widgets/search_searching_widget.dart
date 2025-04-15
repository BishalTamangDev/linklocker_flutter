import 'package:flutter/material.dart';

class SearchSearchingWidget extends StatelessWidget {
  const SearchSearchingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Opacity(
            opacity: 0.6,
            child: Text("Searching"),
          ),
        ],
      ),
    );
  }
}
