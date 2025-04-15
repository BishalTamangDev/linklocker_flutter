import 'package:flutter/material.dart';

class SearchErrorWidget extends StatelessWidget {
  const SearchErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Opacity(
        opacity: 0.6,
        child: Text("An Error Occurred!"),
      ),
    );
  }
}
