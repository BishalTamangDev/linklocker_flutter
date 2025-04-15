import 'package:flutter/material.dart';

class SearchEmptyWidget extends StatelessWidget {
  const SearchEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No Link Found!"),
    );
  }
}
