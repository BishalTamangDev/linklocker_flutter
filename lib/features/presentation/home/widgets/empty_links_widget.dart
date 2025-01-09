import 'package:flutter/material.dart';

class EmptyLinksWidget extends StatelessWidget {
  const EmptyLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36.0),
            child: Column(
              spacing: 16.0,
              children: [
                Icon(Icons.hourglass_empty_outlined),
                Opacity(
                  opacity: 0.6,
                  child: Text("Link hasn't been added yet!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
