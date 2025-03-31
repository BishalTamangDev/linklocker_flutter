import 'dart:math';

import 'package:flutter/material.dart';

class FetchingLinksWidget extends StatelessWidget {
  const FetchingLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        ...List.generate(
          3,
          (data) => Column(
            children: [
              const SizedBox(height: 16.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, index) => Divider(height: 6.0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Random().nextInt(3) + 1,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 24.0,
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                            ),
                            title: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: double.maxFinite,
                                height: 10.0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            subtitle: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 4,
                                height: 10.0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            trailing: Icon(
                              Icons.call,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
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
      ],
    );
  }
}
