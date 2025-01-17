import 'dart:math';

import 'package:flutter/material.dart';

class FetchingLinksWidget extends StatelessWidget {
  const FetchingLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Opacity(
            opacity: 0.6,
            child: Text("Loading your links..."),
          ),
        ),
        ...List.generate(
          5,
          (data) => Column(
            spacing: 12.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) =>
                            Divider(height: 6.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Random().nextInt(3) + 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 24.0,
                              backgroundColor: Theme.of(context).canvasColor,
                            ),
                            title: const Text(""),
                          );
                        },
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
      ],
    );
  }
}

// return Center(
// child: Column(
// spacing: 16.0,
// mainAxisSize: MainAxisSize.min,
// children: const <Widget>[
// CircularProgressIndicator(),
// Opacity(
// opacity: 0.6,
// child: Text("Fetching links"),
// ),
// ],
// ),
// );
//
