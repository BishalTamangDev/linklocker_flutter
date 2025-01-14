import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linklocker/core/constants/app_constants.dart';
import 'package:linklocker/core/constants/app_functions.dart';
import 'package:linklocker/features/data/source/local/local_data_source.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ViewLinkPage extends StatefulWidget {
  const ViewLinkPage({super.key, required this.link});

  final Map<String, dynamic> link;

  @override
  State<ViewLinkPage> createState() => _ViewLinkPageState();
}

class _ViewLinkPageState extends State<ViewLinkPage> {
  // variables
  bool dataUpdated = false;
  Map<String, dynamic> data = {};
  var localDataSource = LocalDataSource.getInstance();

  @override
  void initState() {
    data = widget.link;
    super.initState();
  }

  _refreshLinkData() async {
    Map<String, dynamic> tempData =
        await localDataSource.getLink(widget.link['link_id']);

    List<Map<String, dynamic>> contacts =
        await localDataSource.getContacts(widget.link['link_id']);

    Map<String, dynamic> finalLinkData = Map.from(tempData);
    finalLinkData['contacts'] = contacts;

    developer.log("Refresh link data!");
    developer.log("temp data :: $tempData");
    developer.log("contacts :: $contacts");

    if (mounted) {
      setState(() {
        data = finalLinkData;
      });
    }
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
            onTap: () => context.pop(dataUpdated),
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
                      foregroundImage: data['profile_picture'].isNotEmpty
                          ? MemoryImage(data['profile_picture'])
                          : AssetImage(AppConstants.defaultUserImage),
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
                            leading: Icon(
                              Icons.phone_outlined,
                              color: Colors.green,
                            ),
                            title: Text(
                                "${AppFunctions.getCountryCode(contact['country'])} ${contact['contact']}"),
                            trailing: TextButton(
                              onPressed: () {
                                var data =
                                    "${AppFunctions.getCountryCode(contact['country'])} ${contact['contact']}";
                                AppFunctions.openDialer(data);
                              },
                              child: const Text("call Now"),
                            ),
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

              // delete link
              OutlinedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Column(
                        spacing: 16.0,
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 32.0,
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          const Text(
                              "Are you sure you want to delete this link?"),
                          Row(
                            spacing: 6.0,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // delete
                              Expanded(
                                child: SizedBox(
                                  height: 44.0,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      developer
                                          .log("Link id :: ${data['link_id']}");

                                      String linkDelete = await localDataSource
                                          .deleteLink(data['link_id']);
                                      String contactDelete = "";

                                      if (linkDelete == "success") {
                                        //   delete all contacts of this link
                                        contactDelete = await localDataSource
                                            .deleteContacts(data['link_id']);
                                      }

                                      if (context.mounted) {
                                        setState(() {
                                          dataUpdated = true;
                                        });
                                        context.pop(dataUpdated);

                                        var scaffoldMessenger =
                                            ScaffoldMessenger.of(context);

                                        if (scaffoldMessenger.mounted) {
                                          scaffoldMessenger
                                              .hideCurrentSnackBar();
                                        }

                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(
                                            content: Text(contactDelete ==
                                                    "success"
                                                ? "Link deleted successfully!"
                                                : "Link couldn't be deleted!"),
                                          ),
                                        );

                                        context.pop();
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      overlayColor: Colors.red,
                                    ),
                                    child: Text(
                                      "Yes, Delete Now",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                              ),

                              // keep
                              Expanded(
                                child: SizedBox(
                                  height: 44.0,
                                  child: OutlinedButton(
                                    onPressed: () => context.pop(),
                                    style: OutlinedButton.styleFrom(
                                      overlayColor: Colors.green,
                                    ),
                                    child: Text(
                                      "No, Keep it!",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  // backgroundColor: Colors.red,
                  overlayColor: Colors.red,
                ),
                child: const Row(
                  spacing: 8.0,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Delete Contact"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // bottom actions
      bottomNavigationBar: Container(
        color: colorScheme.surface,
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
                  var qrContacts = data['contacts'];
                  developer.log("temp :: ${qrContacts[0]}");
                  Map<String, dynamic> qrData = {
                    'name': data['name'],
                    'contact':
                        "${AppFunctions.getCountryCode(qrContacts[0]['country'])} ${qrContacts[0]['contact']}",
                  };
                  developer.log("QR data :: $qrData");
                  AppFunctions.showUserQrCode(context, qrData);
                },
                splashColor: colorScheme.surface, // Custom splash color
                highlightColor: colorScheme.surface,
                child: Column(
                  spacing: 6.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.qr_code),
                    const Text("QR Code"),
                  ],
                ),
              ),

              //   edit
              InkWell(
                onTap: () =>
                    context.push('/link/edit', extra: widget.link).then(
                  (returnValue) {
                    _refreshLinkData();
                    if (returnValue == true) {
                      setState(() {
                        dataUpdated = true;
                      });
                    }
                  },
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
                  var name =
                      AppFunctions.getCapitalizedWords(widget.link['name']);

                  var contactMap = widget.link['contacts'][0];

                  var code = AppFunctions.getCountryCode(
                      widget.link['contacts'][0]['country']);

                  var shareData = "$name: $code ${contactMap['contact']}";

                  Share.share(shareData, subject: "qwerty");
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
