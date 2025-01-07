import 'dart:developer' as developer;

import 'package:flutter/material.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key, required this.id});

  final int id;

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var themeContext = Theme.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: themeContext.canvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32.0),

              //   profile picture
              Center(
                child: Column(
                  spacing: 18.0,
                  children: [
                    CircleAvatar(
                      radius: 80.0,
                      backgroundColor: colorScheme.surface,
                      backgroundImage:
                          AssetImage('assets/images/blank_user.png'),
                    ),
                    Text(
                      "Bishal Tamang - ${widget.id}",
                      style: textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),

              //   contacts
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.phone_outlined,
                            color: Colors.green,
                          ),
                          title: Text("+977 9658745214"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.phone_outlined,
                            color: Colors.green,
                          ),
                          title: Text("+977 1234567895"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //   email address
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        color: Colors.deepOrange,
                      ),
                      title: Text("someone@gmail.com"),
                    ),
                  ),
                ),
              ),

              //   birthday
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.cake_outlined,
                        color: Colors.blue,
                      ),
                      title: Text("17th June, 2002"),
                    ),
                  ),
                ),
              ),

              //   category
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.group,
                        color: Colors.orangeAccent,
                      ),
                      title: Text("Family"),
                    ),
                  ),
                ),
              ),

              //   note
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.note_alt_outlined,
                        color: Colors.blue,
                      ),
                      title: Text(
                          "A good friend is like a lighthouse in the storm, guiding you back to calm waters. They celebrate your joys as if they were their own and stand steadfast during your struggles. A good friend listens without judgment, speaks truth with kindness, and reminds you of your worth when you’ve forgotten it. They bring laughter to your darkest days and make life’s best moments even brighter. With a good friend, you never walk alone—because even in silence, their presence feels like home."),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 56.0),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // bottom actions
      floatingActionButton: Container(
        color: themeContext.canvasColor,
        width: mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // contact qr code
              InkWell(
                onTap: () {
                  developer.log("Show qr code of the contact");
                },
                splashColor: colorScheme.surface, // Custom splash color
                highlightColor: colorScheme.surface,
                child: Column(
                  spacing: 6.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.qr_code), const Text("QR Code")],
                ),
              ),

              //   edit
              InkWell(
                onTap: () {
                  developer.log("Edit contact");
                },
                splashColor: colorScheme.surface,
                highlightColor: colorScheme.surface,
                child: Column(
                  spacing: 6.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.edit), const Text("Edit")],
                ),
              ),

              //   share
              InkWell(
                onTap: () {
                  developer.log("Share contact");
                },
                splashColor: colorScheme.surface,
                highlightColor: colorScheme.surface,
                child: Column(
                  spacing: 6.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.share), const Text("Share")],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
