import 'package:flutter/material.dart';

class SearchInitialWidget extends StatelessWidget {
  const SearchInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Opacity(
        opacity: 0.6,
        child: Text("Search links by name or number."),
      ),
    );
  }
}
