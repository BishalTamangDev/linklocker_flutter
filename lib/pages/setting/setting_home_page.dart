import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/data/source/local/local_data_source.dart';

class SettingHomePage extends StatefulWidget {
  const SettingHomePage({super.key});

  @override
  State<SettingHomePage> createState() => _SettingHomePageState();
}

class _SettingHomePageState extends State<SettingHomePage> {
  //  variables
  String status = "null";
  var localDataSource = LocalDataSource.getInstance();

  // reset profile
  Future<bool> _resetProfile() async {
    bool profileResponse = await localDataSource.resetUserTable();

    if (profileResponse) {
      // reset user contact
      profileResponse = await localDataSource.resetUserContactTable();
    }

    return profileResponse;
  }

  // reset links
  Future<bool> _resetLinks() async {
    bool linkResponse = await localDataSource.resetLinkTable();

    if (linkResponse) {
      bool contactResponse = await localDataSource.resetContactTable();
    }

    return linkResponse;
  }

  // reset both :: profile and links
  Future<bool> _resetEverything() async {
    bool profileResponse = await _resetProfile();
    bool userResponse = false;
    if (profileResponse) {
      userResponse = await _resetLinks();
    }
    return userResponse;
  }

  // functions
  _delete(String target) {
    developer.log("Delete :: $target");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          spacing: 12.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              target == "profile"
                  ? "Delete Profile"
                  : target == "link"
                      ? "Delete Links"
                      : "Delete Everything",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                target == "profile"
                    ? "Are you sure you want to delete your profile permanently?"
                    : target == "link"
                        ? "Are you sure you want to delete all your links permanently?"
                        : "Are you sure you want to delete your profile and the links permanently?",
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: 8.0,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    bool response = false;
                    if (target == "profile") {
                      response = await _resetProfile();
                    } else if (target == "link") {
                      response = await _resetLinks();
                    } else if (target == "all") {
                      response = await _resetEverything();
                      if (!context.mounted) return;
                    }

                    if (!context.mounted) return;

                    context.pop();

                    if (ScaffoldMessenger.of(context).mounted) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          response ? "Reset successful!" : "Reset failed!",
                        ),
                      ),
                    );
                  },
                  child: const Text("Yes, Delete Now"),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                  onPressed: () => context.pop(),
                  child: const Text("No, Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Setting"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //   delete profile
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    "Delete Profile",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Your profile details will be deleted."),
                  trailing: IconButton(
                    onPressed: () => _delete("profile"),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              // delete all links
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  title: Text(
                    "Delete all links",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("All the links will be deleted."),
                  trailing: IconButton(
                    onPressed: () => _delete("link"),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              // reset everything
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(
                    "Reset Everything",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                      "Your profile details, as well as all the links will be deleted."),
                  trailing: IconButton(
                    onPressed: () => _delete("all"),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
