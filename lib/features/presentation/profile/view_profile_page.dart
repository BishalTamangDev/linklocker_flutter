import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  // variables
  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = LocalDataSource.getInstance().getUser();
  }

  _refreshUserData() {
    setState(() {
      _userData = LocalDataSource.getInstance().getUser();
    });
  }

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
                    Hero(
                      tag: 'profile_picture',
                      child: CircleAvatar(
                        radius: 80.0,
                        backgroundColor: colorScheme.surface,
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                      ),
                    ),
                    FutureBuilder(
                      future: _userData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            !snapshot.hasError) {
                          return Text(
                            "${snapshot.data!['name']}",
                            style: textTheme.headlineSmall,
                          );
                        } else {
                          return Text("-", style: textTheme.headlineSmall);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(),

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
                          leading: Icon(
                            Icons.phone_outlined,
                            color: AppConstants.callIconColor,
                          ),
                          title: Text("+977 -"),
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
                        color: AppConstants.emailIconColor,
                      ),
                      title: FutureBuilder(
                        future: _userData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              !snapshot.hasError) {
                            return Text("${snapshot.data!['email']}");
                          } else {
                            return Text("-", style: textTheme.headlineSmall);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
                onTap: () => context.push('/profile/edit').then(
                      (_) => _refreshUserData(),
                    ),
                splashColor: colorScheme.surface,
                highlightColor: colorScheme.surface,
                child: Column(
                  spacing: 6.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit),
                    const Text("Edit"),
                  ],
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
