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
                      backgroundImage: AssetImage('assets/images/user.jpg'),
                    ),
                    Text(
                      "Bishal Tamang",
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
                        vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.phone_outlined),
                          title: Text("+977 9658745214"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.phone_outlined),
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
                      leading: Icon(Icons.email_outlined),
                      title: Text("someone@gmail.com"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: mediaQuery.size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // contact qr code
              InkWell(
                hoverColor: Colors.red,
                onTap: () {
                  developer.log("Show qr code of the contact");
                },
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
