import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/core/constants/app_functions.dart';

class ViewLinkPage extends StatefulWidget {
  const ViewLinkPage({super.key, required this.link});

  final Map<String, dynamic> link;

  @override
  State<ViewLinkPage> createState() => _ViewLinkPageState();
}

class _ViewLinkPageState extends State<ViewLinkPage> {
  // variables
  late final Map<String, dynamic> data;

  @override
  void initState() {
    data = widget.link;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var themeContext = Theme.of(context);
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: CircleAvatar(
          radius: 26.0,
          backgroundColor: colorScheme.surface,
          child: InkWell(
            highlightColor: Colors.red,
            onTap: () => context.pop(),
            child: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,

      backgroundColor: themeContext.canvasColor,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64.0),

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
                      AppFunctions.getCapitalizedWords(data['name']),
                      style: textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    child: Column(
                      children: [
                        data['contacts'].length == 0
                            ? ListTile(
                                onTap: () {
                                  developer.log("Call now");
                                },
                                leading: Icon(
                                  Icons.phone_outlined,
                                  color: Colors.green,
                                ),
                                title: Text("-"),
                              )
                            : SizedBox(),

                        ...data['contacts'].map(
                          (contact) => ListTile(
                            onTap: () {
                              developer.log("Call now");
                            },
                            leading: Icon(
                              Icons.phone_outlined,
                              color: Colors.green,
                            ),
                            title: Text(
                                "${AppFunctions.getCountryCode(contact['country'])} ${contact['contact']}"),
                          ),
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
                      title: Text(data['email'] != "" ? data['email'] : "-"),
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
                        color: AppConstants.birthdayIconColor,
                      ),
                      title: Text(
                        data['date_of_birth'] == ""
                            ? "-"
                            : AppFunctions.getFormattedDate(
                                DateTime.parse(data['date_of_birth']),
                              ),
                      ),
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
                        Icons.group_add_outlined,
                        color: AppConstants.categoryIconColor,
                      ),
                      title: Text(
                        AppFunctions.getCapitalizedWord(data['category']),
                      ),
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
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.note_alt_outlined,
                        color: AppConstants.noteIconColor,
                      ),
                      title: Opacity(
                        opacity: 0.5,
                        child: Text(
                          data['note'] != ""
                              ? AppFunctions.getCapitalizedWord(data['note'])
                              : "-",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 32.0),
            ],
          ),
        ),
      ),

      // bottom actions
      bottomNavigationBar: Container(
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
                onTap: showQrCode,
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
                onTap: () => context.push('/link/edit', extra: data),
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

  // show qr code
  void showQrCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Username"),
            Icon(
              Icons.qr_code_2,
              size: 160.0,
            ),
            Text("Scan the QR code above."),
          ],
        ),
      ),
    );
  }
}
