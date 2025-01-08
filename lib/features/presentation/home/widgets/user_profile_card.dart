import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          spacing: 20.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(),
            ListTile(
              leading: Hero(
                tag: 'profile_picture',
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundImage: AssetImage('assets/images/user.jpg'),
                ),
              ),
              title: Text("Bishal Tamang"),
              trailing: IconButton(
                onPressed: () {
                  developer.log("Share user profile");

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Column(
                        spacing: 16.0,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("John Doe"),
                          Container(
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset('assets/images/app_qr.png'),
                            ),
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: const Text(
                                "Scan the QR code to add this contact."),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.share),
              ),
              onTap: () => context.push('/profile/view'),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
